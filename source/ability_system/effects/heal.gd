extends GameplayAbilityEffect
class_name AbilityEffectHeal

var heal_percentage = 0.3

func execute(target, user):
	user.heal(user.max_health * heal_percentage)  # 回复使用者的生命
