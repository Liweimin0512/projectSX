extends Node
class_name C_AbilitySystem

const component_name : String = "C_AbilitySystem"

var attribute_sets = {}
var abilities = {}  # 存储所有Ability对象
var effects = {}    # 存储当前活跃的Effect对象

func _init(attribute_set_definitions: Dictionary):
	for set_name in attribute_set_definitions:
		attribute_sets[set_name] = GameplayAttributeSet.new(attribute_set_definitions[set_name])

func execute_ability(ability_name: String, target, player):
	if can_execute_ability(ability_name, player):
		player.energy -= abilities[ability_name].energy_cost
		abilities[ability_name].activate(target)

func apply_effect(effect: GameplayAbilityEffect):
	effects[effect.get_id()] = effect
	effect.apply(self)

func remove_effect(effect_id):
	if effects.has(effect_id):
		effects[effect_id].remove()
		effects.erase(effect_id)

func get_attribute(attribute_name, set_name):
	if set_name in attribute_sets:
		return attribute_sets[set_name].get_attribute(attribute_name)
	return null

func modify_attribute(attribute_name, set_name, amount):
	if set_name in attribute_sets:
		attribute_sets[set_name].modify_attribute(attribute_name, amount)

func can_execute_ability(ability_name: String, player) -> bool:
	var ability = abilities[ability_name]
	return player.energy >= ability.energy_cost
