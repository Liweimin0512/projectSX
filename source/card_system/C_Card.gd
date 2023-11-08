extends Node
class_name C_Card

const component_name : StringName = "C_Card"

var card_data : CardModel
var abilityID : StringName :
	get:
		return card_data.abilityID
var ability : GameplayAbility

func _init(card_id: StringName) -> void:
	card_data = CardModel.new(card_id)

func needs_target() -> bool:
	return false

func can_release() -> bool:
	return false
