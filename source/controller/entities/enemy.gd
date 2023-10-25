extends Character
class_name Enemy

var enemy_data: EnemyModel

var combat_scene : CombatScene

signal action_before
signal action_end

func _init(enemy_id: StringName) -> void:
	super(enemy_id)
	enemy_data = EnemyModel.new(enemy_id)

## 怪物回合开始
func begin_turn() -> void:
	print(cha_data.cha_name, " 回合开始")
	action()

## 怪物回合结束
func end_turn() -> void:
	pass
	
func action() -> void:
	action_before.emit()
	await action_end
	print("造成伤害")
	combat_scene.end_turn()
