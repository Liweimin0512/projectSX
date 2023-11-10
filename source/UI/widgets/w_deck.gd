extends MarginContainer
class_name W_Deck

@onready var lab_card_amount: Label = $MarginContainer/lab_card_amount
@onready var cards: Control = $cards

@export var deck_type: CardDeckModel.DECK_TYPE
var _deck: CardDeck

func _ready() -> void:
	var c_card_sytem: C_CardSystem = GameInstance.player.get_node("C_CardSystem")
	_deck = c_card_sytem.get_deck(deck_type)
	_deck.card_added.connect(_on_card_added)
	_deck.card_removed.connect(_on_card_removed)
	_deck.card_drawed.connect(_on_card_drawed)
	for c in _deck.get_card_list():
		cards.add_child(c)

func set_card_amount(amount:int) -> void:
	lab_card_amount.text = str(amount)

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func _on_card_added(card: Card) -> void:
	cards.add_child(card)

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func _on_card_removed(card: Card) -> void:
	cards.remove_child(card)

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func _on_card_drawed(card: Card) -> void:
	cards.remove_child(card)
