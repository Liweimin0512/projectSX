extends RefCounted
class_name GameplayAttributeSet

var attributes = {}

func _init(attribute_definitions):
	for attribute_name in attribute_definitions:
		attributes[attribute_name] = GameplayeAttribute.new(attribute_definitions[attribute_name])

func get_attribute(attribute_name):
	return attributes[attribute_name] if attribute_name in attributes else null

func modify_attribute(attribute_name, amount):
	if attribute_name in attributes:
		attributes[attribute_name].modify_value(amount)

