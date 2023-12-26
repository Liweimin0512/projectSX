extends SceneBase
class_name CombatScene

## character角色出生点位的引用
@onready var markers: Array = [
	%Marker2D1, # 玩家位置
	%Marker2D2, # 预留1
	%Marker2D3, # 预留2
	%Marker2D4, # 怪物1
	%Marker2D5, # 怪物2
	%Marker2D6, # 怪物3
]
## 战斗场景UI界面的引用
@onready var combat_form: Control = %combat_form
## 当前战斗中的角色引用，在完成场景初始化后就不变了
var characters : Array = []
## 当前回合的角色的引用，方便切换回合
var current_character: Character = null

## 关卡成功
signal succeeded
## 关卡失败
signal failed

## 进入当前场景，开始战斗
func _enter(msg:Dictionary = {}) -> void:
	if not "combat_id" in msg:
		push_error("combatScene初始化失败，没找到combat_id")
		return
	var combat_id = msg.combat_id
	var player: Character = msg.player
	_init_combat(combat_id, player)

## 退出当前场景，结束战斗
func _exit() -> void:
	_end_combat()

## 初始化战斗
func _init_combat(combat_id : StringName, player: Character) -> void:
	var data: Dictionary = DatatableManager.get_datatable_row("combat", combat_id)
	combat_form.end_turn_pressed.connect(
		func() -> void:
			if _is_player_turn(player):
				_next_turn()
	)
	player.died.connect(
		func() -> void:
			print("player 死亡，关卡失败！")
			failed.emit()
	)
	_init_player(player)
	_create_enemy(data.mark_04, 3)
	_create_enemy(data.mark_05, 4)
	_create_enemy(data.mark_06, 5)
	_begin_combat()

## 开始战斗，战斗初始化
func _begin_combat() -> void:
	await get_tree().create_timer(0.5).timeout
	for cha in characters:
		cha._begin_combat()
	_next_turn()

## 切换回合
func _next_turn() -> void:
	if current_character:
		current_character._end_turn()
		current_character = _get_next_character()
	else:
		current_character = characters[0]
	if current_character.is_death:
		current_character = _get_next_character()
	if current_character:
		await current_character._begin_turn()
	combat_form.next_turn(current_character)

## 结束战斗
func _end_combat() -> void:
	for cha in characters:
		cha._end_combat()

## 初始化玩家角色
func _init_player(player: Character) -> void:
	player.get_parent().remove_child(player)
	markers[0].add_child(player)
	characters.append(player)
	
## 创建敌人
func _create_enemy(enemyID: StringName, markerID: int) -> void:
	if enemyID.is_empty(): return
	var enemy_path: String = AssetUtility.get_entity_path(DatatableManager.get_datatable_row("monster", enemyID)["enemy_scene"])
	var enemy :  = GameInstance.create_entity(enemy_path)
	enemy.turn_begined.connect(
		func() -> void:
			_next_turn()
	)
	enemy.died.connect(
		func() -> void:
			print("判断是否关卡成功")
			for e in get_tree().get_nodes_in_group("enemy"):
				if not e.is_death:
					return
			print("战斗胜利！")
			succeeded.emit()
	)
	enemy.cha_id = enemyID
	markers[markerID].add_child(enemy)
	characters.append(enemy)

## 获取下一个回合的角色
func _get_next_character() -> Character:
	if not current_character: return characters[0]
	for i in characters.size():
		if current_character == characters[i]:
			if i >= characters.size() - 1:
				return characters[0]
			else:
				return characters[i + 1]
	return characters[0]

## 判断当前是否为玩家回合
func _is_player_turn(player: Character) -> bool:
	return current_character == player
