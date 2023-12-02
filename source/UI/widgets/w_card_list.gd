extends Control

@onready var grid_container: GridContainer = %GridContainer
@onready var label: Label = %Label
@onready var btn_close: Button = %btn_close

var _deck: CardDeck

func _ready() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	btn_close.pressed.connect(_on_btn_close_pressed)

func _on_visibility_changed() -> void:
	if self.visible == true:
		label.text = _deck.deck_des
		for card in _deck.get_card_list():
			#var dc = card.duplicate()
			var dc = card
			grid_container.add_child(dc)

func _on_btn_close_pressed() -> void:
	for card in grid_container.get_children():
		card.queue_free()
	self.hide()
