extends Resource
class_name CharacterModel

signal health_changed(value)

@export var cha_name : StringName = ""
@export var cha_des : String = ""
@export var max_health : int = 0
@export var attack: int = 0
var current_health : int = max_health : 
	set(value): 
		health_changed.emit(value)
		current_health = value

var shielded: int = 0

func _init(cha_id: StringName) -> void:
	var data: Dictionary = DatatableManager.get_datatable_row("character", cha_id)
	cha_name = data.name
	cha_des = data.description
	max_health = data.health
	attack = data.attack
	current_health = max_health
