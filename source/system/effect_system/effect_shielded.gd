extends Effect
class_name EffectShielded

var shielded := 0

func _init(data: Dictionary) -> void:
	shielded = int(data.effect_parameters[0])
	super(data)

func execute() -> void:
	for target : Character in _targets:
		target.add_shielded(shielded)
