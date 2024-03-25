extends Effect
class_name EffectDamage

var value := 0

func _init(data: Dictionary) -> void:
	value = int(data.effect_parameters[0])
	super(data)

func execute() -> void:
	for cha in self._targets:
		assert(cha != null, "找不到目标！")
		cha.damage(Damage.new(value))
