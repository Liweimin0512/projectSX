extends Control

@onready var grid_container: GridContainer = %GridContainer
@onready var label: Label = %Label
@onready var btn_close: Button = %btn_close
@onready var label_name: Label = $VBoxContainer/label_name

var w_deck: W_Deck

func _ready() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	btn_close.pressed.connect(_on_btn_close_pressed)
	for c in grid_container.get_children():
		c.queue_free()
	self.hide()

func _on_visibility_changed() -> void:
	var _deck: CardDeck = w_deck._deck
	if self.visible == true:
		label_name.text = _deck.deck_name
		label.text = _deck.deck_des
		w_deck.z_index = 1
		for card in _deck.get_card_list():
			var w_card: W_Card = W_CardManager.create_card_widget(card)
			grid_container.add_child(w_card)
			w_card.mouse_entered.connect(
				func() -> void:
					#w_card.scale *= 1.2
					pass
			)
			w_card.mouse_exited.connect(
				func() -> void:
					pass
			)
	else:
		w_deck.z_index = 0

func _on_btn_close_pressed() -> void:
	for card in grid_container.get_children():
		card.queue_free()
	self.hide()
