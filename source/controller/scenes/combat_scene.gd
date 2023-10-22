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

signal combat_begined

func _enter(msg:Dictionary = {}) -> void:
	var combat_id = msg.combat_id
	combat_data = CombatModel.new(combat_id)
	for i in range(0, combat_data.characters.values().size()):
		var enemy_id = combat_data.characters.values()[i]
		if enemy_id != null:
			var ememy: Enemy = Enemy.new(enemy_id)
			markers[i] = ememy
	markers[1] = GameInstance.game_main.player

## 开始战斗
func begin_combat() -> void:
	pass
#	begin_turn()

## 开始回合
func begin_turn() -> void:
#	var marker: Marker2D = marker_list[current_marker]
#	if marker.get_child_count() <= 0:
#		current_marker += 1
#		begin_turn()
#		return
#	var cha: CharacterView = marker.get_child(0)
#	cha.begin_turn()
	pass

## 结束回合
func end_turn() -> void:
	pass

## 结束战斗
func end_combat() -> void:
	pass
