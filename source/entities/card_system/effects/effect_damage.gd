extends Effect
class_name EffectDamage

var damage := 0

func _init(data: Dictionary, targets: Array) -> void:
	super(data, targets)
	damage = data.effect_parameters[0]

func execute() -> void:
	for cha in self._targets:
		cha.damage(damage)
