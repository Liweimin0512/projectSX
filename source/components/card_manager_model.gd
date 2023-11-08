extends Resource
class_name CardManagerModel

## 手牌
var hand_cards : Array[CardLogic] = []

## 默认每回合可抽取5张卡牌
var distribute_card_amount := 5

var discard_deck: CardDeckLogic
var draw_deck: CardDeckLogic
var initial_deck: Array

func _init(id: StringName) -> void:
	initial_deck = DatatableManager.get_datatable_row("hero", id)["initial_deck"]
	discard_deck = CardDeckLogic.new("弃牌堆", 0)
	draw_deck = CardDeckLogic.new("抽牌堆", 1)
