extends Effect
class_name EffectDamage

var damage := 0

func _init(data: Dictionary, targets: Array) -> void:
	super(data, targets)
	damage = int(data.effect_parameters[0])

func execute() -> void:
	for cha in self._targets:
		assert(cha != null, "找不到目标！")
		cha.damage(damage)
