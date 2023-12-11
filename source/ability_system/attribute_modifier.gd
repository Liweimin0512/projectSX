extends RefCounted
class_name GameplayAttributeModifier

enum ModifierType {
	FLAT,       # 直接增减值
	PERCENT     # 百分比修改
}

var type: ModifierType
var value: float
var duration: float = -1  # 持续时间，负值表示永久
var source  # 来源可以是任何类型，例如，技能、物品等

func _init(modifier_type: ModifierType, modifier_value: float, modifier_duration: float = -1, modifier_source = null):
	type = modifier_type
	value = modifier_value
	duration = modifier_duration
	source = modifier_source

func is_expired(delta: float) -> bool:
	if duration < 0:
		return false  # 永久修改器不会过期
	duration -= delta
	return duration <= 0
