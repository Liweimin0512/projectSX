extends Resource
class_name PlayerModel

## 抽牌堆
var draw_deck : CardDeck : 
	get:
		return CardManager.draw_deck
	set(value):
		pass

## 弃牌堆
var discard_deck: CardDeck :
	get:
		return CardManager.discard_deck
	set(value):
		pass

## 能量：释放卡牌用，默认初始4点
var energy :int = 4

func _init(hero_id: String) -> void:
	var data :Dictionary = DatatableManager.get_datatable_row("hero", hero_id)
	var initial_deck = data.initial_deck
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			draw_deck.add_card(CardManager.create_card(card_id))
