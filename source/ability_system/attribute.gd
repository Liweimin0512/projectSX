extends RefCounted
class_name GameplayeAttribute

var base_value = 0
var current_value: float : set = set_current_value

var modifiers = []

func _init(_base_value):
	base_value = _base_value
	current_value = _base_value

func set_current_value(new_value: float):
	current_value = clamp(new_value, 0, base_value)
	# 通知系统属性改变，例如通过信号

func modify_value(modifier: float):
	set_current_value(current_value + modifier)

func reset():
	current_value = base_value

func apply_modifier(modifier: GameplayAttributeModifier):
	modifiers.append(modifier)
	recalculate_current_value()

func remove_modifier(modifier: GameplayAttributeModifier):
	modifiers.erase(modifier)
	recalculate_current_value()

func recalculate_current_value():
	var modifier_value = 0
	var percentage_value = 0
	for modifier in modifiers:
		match modifier.type:
			GameplayAttributeModifier.ModifierType.FLAT:
				modifier_value += modifier.value
			GameplayAttributeModifier.ModifierType.PERCENT:
				percentage_value += modifier.value
	var total_modifier = base_value * percentage_value / 100.0 + modifier_value
	set_current_value(base_value + total_modifier)

func update(delta: float):
	for modifier in modifiers:
		if modifier.is_expired(delta):
			remove_modifier(modifier)
