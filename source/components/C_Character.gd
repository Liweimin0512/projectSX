extends Node
class_name C_Character

const component_name : StringName = "C_Character"

var _model: CharacterModel

@export var health_bar: ProgressBar
@export var health_label: Label

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

func _init(cha_id: StringName) -> void:
	_model = CharacterModel.new(cha_id)

func _ready() -> void:
	display_health_bar()

## 开始战斗
func begin_play() -> void:
	pass

## 结束战斗
func end_play() -> void:
	pass

## 回合开始时
func begin_turn() -> void:
	pass

## 回合结束时
func end_turn() -> void:
	pass

func display_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)
