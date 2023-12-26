extends Effect
class_name EffectShielded

var shielded := 0

func _init(data: Dictionary, caster: Character, targets: Array) -> void:
	super(data, caster, targets)
	shielded = int(data.effect_parameters[0])

func execute() -> void:
	for target : Character in _targets:
		target.add_shielded(shielded)
