extends EntityBase
class_name Card

var card_data : CardModel

func _init(card_id: StringName) -> void:
	card_data = CardModel.new(card_id)

func needs_target() -> bool:
	return false

func can_release() -> bool:
	return false
