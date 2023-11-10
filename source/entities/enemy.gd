extends Character
class_name Enemy

var _enemy_model : EnemyModel

@export var animation_player: AnimationPlayer

signal action_before
signal action_end

func _ready() -> void:
	super()
	_enemy_model = EnemyModel.new(cha_id)
