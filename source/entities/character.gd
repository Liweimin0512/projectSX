extends Node2D
class_name Character

@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label

signal health_changed(value)

@export var max_health : int = 0
@export var attack: int = 0
var current_health : int = max_health : 
	set(value): 
		health_changed.emit(value)
		current_health = value
		display_health_bar()

func _ready() -> void:
	current_health = max_health

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
