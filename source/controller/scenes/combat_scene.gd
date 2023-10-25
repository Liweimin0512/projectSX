extends SceneBase
class_name CombatScene

var combat_data: CombatModel

var markers: Array = [
	null,	# 玩家位置
	null,
	null,
	null,	# 怪物1
	null,	# 怪物2
	null,	# 怪物3
]
var current_marker := 0

signal combat_begined

func _enter(msg:Dictionary = {}) -> void:
	var combat_id = msg.combat_id
	begin_combat(combat_id)

## 开始战斗
func begin_combat(combat_id: StringName) -> void:
	combat_data = CombatModel.new(combat_id)
	for i in range(0, combat_data.characters.values().size()):
		var enemy_id = combat_data.characters.values()[i]
		if enemy_id != null:
			var enemy: Enemy = Enemy.new(enemy_id)
			enemy.combat_scene = self
			markers[i] = enemy
	markers[0] = GameInstance.game_main.player
	begin_turn()

## 开始回合
func begin_turn() -> void:
	var cha : Character = markers[current_marker]
	if cha == null:
		_get_next_marker()
		begin_turn()
	else:
		cha.begin_turn()

## 结束回合
func end_turn() -> void:
	var cha: Character = markers[current_marker]
	cha.end_turn()
	_get_next_marker().begin_turn()

## 获取下一个位置的角色
func _get_next_marker() -> Character:
	if current_marker >= markers.size() -1:
		current_marker = 0
	else:
		current_marker += 1
	if markers[current_marker] == null:
		return _get_next_marker()
	return markers[current_marker]

## 结束战斗
func end_combat() -> void:
	pass
