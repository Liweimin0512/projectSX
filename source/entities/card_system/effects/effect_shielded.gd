extends Effect
class_name EffectShielded

var shielded := 0

func _init(data: Dictionary, targets: Array) -> void:
	super(data, targets)
	shielded = data.effect_parameters[0]

func execute() -> void:
	for cha in self._targets:
		cha.add_shielded(shielded)
