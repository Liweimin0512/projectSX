extends SceneBase
class_name CombatScene

@onready var combat_scene_controller: Node = %CombatSceneController

## 对于Controller层的引用
@onready var markers: Array = [
	%Marker2D1, # 玩家位置
	%Marker2D2, # 预留1
	%Marker2D3, # 预留2
	%Marker2D4, # 怪物1
	%Marker2D5, # 怪物2
	%Marker2D6, # 怪物3
]

@onready var combat_form: Control = $CanvasLayer2/combat_form
var characters : Array = []
var current_character: Character = null
## 选中的目标
var cha_selected: Character = null

signal successed

func _ready() -> void:
	combat_form.end_turn_pressed.connect(
		func() -> void:
			if is_player_turn():
				next_turn()
	)
	EventBus.subscribe("character_mouse_entered", 
		func(cha: Character) -> void:
			cha_selected = cha
	)
	EventBus.subscribe("character_mouse_exited", 
		func(cha: Character) -> void:
			assert(cha == cha_selected)
			cha_selected = null
	)
	var player: Character = GameInstance.player
	player.died.connect(game_over)

## 进入当前场景，开始战斗
func _enter(msg:Dictionary = {}) -> void:
	if not "combat_id" in msg:
		push_error("combatScene初始化失败，没找到combat_id")
		return
	var combat_id = msg.combat_id
	init_combat(combat_id)

## 初始化战斗
func init_combat(combat_id : StringName) -> void:
	var data: Dictionary = DatatableManager.get_datatable_row("combat", combat_id)
	_init_player()
	_create_enemy(data.mark_04, 3)
	_create_enemy(data.mark_05, 4)
	_create_enemy(data.mark_06, 5)
	begin_combat()

## 开始战斗，战斗初始化
func begin_combat() -> void:
	await get_tree().create_timer(0.5).timeout
	for cha in characters:
		cha._begin_combat()
	next_turn()

## 切换回合
func next_turn() -> void:
	if current_character:
		current_character._end_turn()
		current_character = _get_next_character()
	else:
		current_character = characters[0]
	if current_character.is_death:
		current_character = _get_next_character()
	if current_character:
		#if current_character == GameInstance.player:
			#_player_turn_begin()
		#await get_tree().create_timer(1.5).timeout
		await current_character._begin_turn()
	combat_form.next_turn(current_character)

## 结束战斗
func end_combat() -> void:
	for cha in characters:
		cha._end_combat()

## 初始化玩家角色
func _init_player() -> void:
	var player : Character = GameInstance.player
	player.get_parent().remove_child(player)
	markers[0].add_child(GameInstance.player)
	characters.append(player)
	
## 创建敌人
func _create_enemy(enemyID: StringName, markerID: int) -> void:
	if enemyID.is_empty(): return
	var enemy_path: String = AssetUtility.get_entity_path(DatatableManager.get_datatable_row("monster", enemyID)["enemy_scene"])
	var enemy :  = GameInstance.create_entity(enemy_path)
	enemy.turn_begined.connect(
		func() -> void:
			next_turn()
	)
	enemy.died.connect(
		func() -> void:
			print("判断是否关卡成功")
			for e in get_tree().get_nodes_in_group("enemy"):
				if not e.is_death:
					return
			print("战斗胜利！")
			successed.emit()
	)
	enemy.cha_id = enemyID
	markers[markerID].add_child(enemy)
	characters.append(enemy)

func _get_next_character() -> Character:
	if not current_character: return characters[0]
	for i in characters.size():
		if current_character == characters[i]:
			if i >= characters.size() - 1:
				return characters[0]
			else:
				return characters[i + 1]
	return characters[0]

#func _player_turn_begin() -> void:
	#for cha in characters:
		#if cha != GameInstance.player:
			#cha.on_player_turn_begined()

func is_player_turn() -> bool:
	return current_character == GameInstance.player

func game_over() -> void:
	print("游戏结束！")
	get_tree().paused = true
