extends Node2D
class_name Character

signal health_changed(value)

@export var max_health : int = 100

var main := get_parent()
var current_health : int : 
	set(value): 
		health_changed.emit(value)
		current_health = value

func _ready() -> void:
	current_health = max_health
	

func begin_play() -> void:
	pass

func end_play() -> void:
	pass

func begin_turn() -> void:
	pass

func end_turn() -> void:
	pass
