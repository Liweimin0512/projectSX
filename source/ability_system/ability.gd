extends RefCounted
class_name GameplayAbility

var effects = []  # 技能可以包含多个Effect

func activate(target, user):
	for effect in effects:
		effect.execute(target, user)  # 每个效果都执行它的逻辑
