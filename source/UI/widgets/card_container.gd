extends Control
class_name CardContainer

@onready var t_card_view : PackedScene = preload(AssetUtility.card_view)
@onready var hand_card : W_HandCardContainer = %hand_card
@onready var draw_deck : W_Deck = %draw_deck
@onready var discard_deck : W_Deck = %discard_deck
@onready var arrow :Node2D = $bessel_arrow

var card_remove_index := 0

var _controller : CardManagerLogic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_controller = GameInstance.player.get_component("CardManager")
#	card_preview.pivot_offset = Vector2(card_preview.size.x/2,card_preview.size.y)
#	card_preview.hide()
	_controller.card_distributed.connect(
		func(cards: Array) -> void:
			draw_card(cards)
	)

## 抽卡
func draw_card(cards: Array) -> void:
	for card in cards:
		var w_card : CardView = t_card_view.instantiate()
		w_card._controller = card
		w_card.global_position = draw_deck.global_position
		hand_card.add_card(w_card)
