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
	set_card_amount(cards.get_child_count())

func set_card_amount(amount:int) -> void:
	lab_card_amount.text = str(amount)

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func _on_card_added(card: Card) -> void:
	cards.add_child(card)
	set_card_amount(cards.get_child_count())

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func _on_card_removed(card: Card) -> void:
	cards.remove_child(card)
	set_card_amount(cards.get_child_count())

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func _on_card_drawed(card: Card) -> void:
	cards.remove_child(card)
	set_card_amount(cards.get_child_count())

func _make_custom_tooltip(for_text: String) -> Object:
	var w_tooltip = load("res://source/UI/widgets/w_tooltip.tscn").instantiate()
	w_tooltip.set_tooltip(_deck.deck_name, "在每回合开始时，你从这里抽5张牌，点击查看你抽牌堆中的牌（但顺序是打乱的）")
	return w_tooltip
