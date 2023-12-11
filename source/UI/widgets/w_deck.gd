extends MarginContainer
class_name W_Deck

@onready var lab_card_amount: Label = $MarginContainer/lab_card_amount
@export var deck_type: CardDeckModel.DECK_TYPE
var _deck: CardDeck

signal pressed

func _ready() -> void:
	var c_card_sytem: C_CardSystem = GameInstance.player.get_node("C_CardSystem")
	_deck = c_card_sytem.get_deck(deck_type)
	_deck.card_added.connect(_on_card_added)
	_deck.card_removed.connect(_on_card_removed)
	_deck.card_drawed.connect(_on_card_drawed)
	self.gui_input.connect(_on_gui_input)
	update_display()

func update_display() -> void:
	lab_card_amount.text = str(_deck.get_card_amount())

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func _on_card_added(card: Card) -> void:
	update_display()

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func _on_card_removed(card: Card) -> void:
	update_display()

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func _on_card_drawed(card: Card) -> void:
	update_display()

func _make_custom_tooltip(for_text: String) -> Object:
	var w_tooltip = load("res://source/UI/widgets/w_tooltip.tscn").instantiate()
	w_tooltip.set_tooltip(_deck.deck_name, "在每回合开始时，你从这里抽5张牌，点击查看你抽牌堆中的牌（但顺序是打乱的）")
	return w_tooltip

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			pressed.emit()