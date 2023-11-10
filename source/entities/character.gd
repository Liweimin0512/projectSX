extends Node2D
class_name Character

var cha_id: StringName

var _model: CharacterModel

@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal play_begined

## 控制器引用
var current_health: float:
	get:
		return _model.current_health
	set(value):
		pass

var max_health: float:
	get:
		return _model.max_health
	set(value):
		pass

func _ready() -> void:
	_model = CharacterModel.new(cha_id)
	display_health_bar()

## 开始战斗
func _begin_combat() -> void:
	pass

## 结束战斗
func _end_combat() -> void:
	pass

## 回合开始时
func _begin_turn() -> void:
	pass

## 回合结束时
func _end_turn() -> void:
	pass

func display_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)
