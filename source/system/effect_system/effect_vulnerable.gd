extends Effect
class_name EffectVulnerable

## 易伤效果：受到的伤害 1.5 倍
var value: float = 1.5
var damage : Damage

func execute() -> void:
	damage.value *= value
