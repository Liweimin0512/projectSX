extends RefCounted
class_name CardDeck

enum DECK_TYPE{
		DRAW,
		DISCARD
	}

var card_list : Array = []
var deck_type : DECK_TYPE = DECK_TYPE.DRAW
var deck_name : StringName = "抽牌堆"

signal card_added
signal card_removed
signal shuffled
signal drawed

func _init(d_name: StringName, type: int) -> void:
	deck_name = d_name
	deck_type = type

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func add_card(card: Card) -> void:
	card_list.append(card)

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func remove_card() -> void:
	pass

## 洗牌(Shuffle)：将牌组中的卡牌重新洗牌。
func shuffle() -> void:
	card_list.shuffle()

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func draw_card() -> Card:
	shuffle()
	var card : Card = card_list.pop_front()
	return card
