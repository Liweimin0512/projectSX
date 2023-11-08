extends RefCounted
class_name GameplayTrigger

var conditions = []
var effects = []

func _init(_conditions, _effects):
	conditions = _conditions
	effects = _effects

func check_conditions(event):
	for condition in conditions:
		if not condition.is_met(event):
			return false
	return true

func activate():
	for effect in effects:
		effect.apply()
