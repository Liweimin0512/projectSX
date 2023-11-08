extends Resource
class_name CardManagerModel

## 手牌
var hand_cards : Array[C_Card] = []

## 默认每回合可抽取5张卡牌
var distribute_card_amount := 5

var discard_deck: CardDeck
var draw_deck: CardDeck
var initial_deck: Array

func _init(id: StringName, discard: CardDeck, draw: CardDeck) -> void:
	initial_deck = DatatableManager.get_datatable_row("hero", id)["initial_deck"]

