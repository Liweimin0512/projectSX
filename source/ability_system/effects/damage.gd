extends GameplayAbilityEffect
class_name AbilityEffectDamage

var damage_amount = 10

func execute(target, user):
	target.apply_damage(damage_amount)  # 对目标造成伤害
