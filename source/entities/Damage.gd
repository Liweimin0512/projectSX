extends RefCounted
class_name Damage

var value: float = 0

func _init(damage: float) -> void:
	value = damage

func _to_string() -> String:
	return str(value)
