extends Node
class_name C_Enemy

const component_name : String = "C_Enemy"

var _model : EnemyModel
var _combat_scene : Entity

@export var animation_player: AnimationPlayer

signal action_before
signal action_end

func _init(enemy_id: StringName) -> void:
	_model = EnemyModel.new(enemy_id)

func _ready() -> void:
	pass
