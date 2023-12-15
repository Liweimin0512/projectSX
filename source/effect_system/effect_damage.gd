extends Effect
class_name EffectDamage

var value := 0

func _init(data: Dictionary, caster: Character, targets: Array) -> void:
	super(data, caster, targets)
	value = int(data.effect_parameters[0])

func execute() -> void:
	for cha in self._targets:
		assert(cha != null, "找不到目标！")
		var damage = Damage.new(value)
		cha.damage(damage)
