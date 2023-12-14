extends Control

@onready var grid_container: GridContainer = %GridContainer
@onready var label: Label = %Label
@onready var btn_close: Button = %btn_close
@onready var label_name: Label = %label_name

var w_deck: W_Deck

func _ready() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	btn_close.pressed.connect(_on_btn_close_pressed)
	for c in grid_container.get_children():
		c.queue_free()
	self.hide()

func _on_visibility_changed() -> void:
	if not w_deck : return
	var _deck: CardDeck = w_deck._deck
	if self.visible == true:
		label_name.text = _deck.deck_name
		label.text = _deck.deck_des
		w_deck.z_index = 1
		var card_list = _deck.get_card_list()
		card_list.sort_custom(
			func(a, b): 
				return a.card_name.naturalnocasecmp_to(b.card_name) < 0
		)
		for card in card_list:
			var w_card: W_Card = W_CardManager.create_card_widget(card)
			grid_container.add_child(w_card)
			w_card.pivot_offset = w_card.size / 2
			w_card.mouse_entered.connect(
				func() -> void:
					w_card.scale *= 1.5
					w_card.z_index = 1
					w_card.preview()
			)
			w_card.mouse_exited.connect(
				func() -> void:
					w_card.scale = Vector2.ONE
					w_card.z_index = 0
					w_card.cancel_preview()
			)
	else:
		w_deck.z_index = 0

func _on_btn_close_pressed() -> void:
	for card in grid_container.get_children():
		card.queue_free()
	self.hide()
