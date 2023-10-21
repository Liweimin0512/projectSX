extends Character
class_name PlayerCharacter

var hero_name : String
var hero_story : String
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

func init(hero_id: String) -> void:
	var data :Dictionary = DatatableManager.get_datatable_row("hero", hero_id)
	hero_name = data.hero_name
	max_health = data.health
	hero_story = data.background_story
	var initial_deck = data.initial_deck
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			draw_deck.add_card(CardManager.create_card(card_id))

## 回合开始时
func begin_turn() -> void:
	CardManager.distribute_card()
