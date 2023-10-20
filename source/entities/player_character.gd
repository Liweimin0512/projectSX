extends Character
class_name PlayerCharacter

var hero_name : String
var health : int
var hero_story : String
var deck : Array = []

func init(hero_id:String) -> void:
	var data :Dictionary = DatatableManager.get_datatable_row("hero", hero_id)
	hero_name = data.hero_name
	health = data.health
	hero_story = data.background_story
	var initial_deck = data.initial_deck
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			deck.append(CardManager.create_card(card_id))
