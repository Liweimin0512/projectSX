extends RefCounted
class_name CardManager

const component_name : StringName = "CardManager"

var _models : CardManagerModel

var distribute_card_amount: int :
	get:
		return _models.distribute_card_amount
var draw_deck : CardDeck :
	get:
		return _models.draw_deck
var discard_deck: CardDeck :
	get:
		return _models.discard_deck
var hand_cards : Array :
	get:
		return _models.hand_cards
var initial_deck: Array :
	get:
		return _models.initial_deck

signal card_distributed

func _init(playerID: StringName) -> void:
	_models = CardManagerModel.new(playerID)
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			draw_deck.add_card(create_card(card_id))

## 创建卡牌(Create Card)：根据指定的参数创建新卡牌。
func create_card(card_name:String) -> Card:
	var card = Card.new(card_name)
	return card

## 升级卡牌(Upgrade Card)：升级指定的卡牌。
func upgrade_card() -> void:
	pass

## 分发卡牌(Distribute Card)：在游戏开始或特定事件时分发卡牌给玩家。
func distribute_card() -> void:
	for i in range(0, distribute_card_amount):
		var card : Card = draw_deck.draw_card()
		hand_cards.append(card)
	card_distributed.emit(hand_cards)
