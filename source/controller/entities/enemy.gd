extends Character
class_name Enemy

var enemy_data: EnemyModel

func _init(enemy_id: StringName) -> void:
	super(enemy_id)
	enemy_data = EnemyModel.new(enemy_id)
