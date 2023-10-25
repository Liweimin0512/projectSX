extends MarginContainer
class_name W_Deck

@onready var lab_card_amount: Label = $MarginContainer/lab_card_amount

func set_card_amount(amount:int) -> void:
	lab_card_amount.text = str(amount)
