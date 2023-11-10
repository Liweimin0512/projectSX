extends Node
class_name C_CardSystem

var distribute_card_amount: int = 5
var discard_deck: CardDeck = CardDeck.new("弃牌堆", 0)
var draw_deck : CardDeck = CardDeck.new("抽牌堆", 1)
var hand_cards : Array = []
var initial_deck: Array

#signal card_distributed

func component_init(playerID: StringName) -> void:
	initial_deck = DatatableManager.get_datatable_row("hero", playerID)["initial_deck"]
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			draw_deck.add_card(create_card(card_id))

## 创建卡牌(Create Card)：根据指定的参数创建新卡牌。
func create_card(cardID : StringName) -> Card:
	var card: Card = GameInstance.create_entity(AssetUtility.get_entity_path("card"))
	card.cardID = cardID
	return card

## 升级卡牌(Upgrade Card)：升级指定的卡牌。
func upgrade_card() -> void:
	pass

## 分发卡牌(Distribute Card)：在游戏开始或特定事件时分发卡牌给玩家。
func distribute_card() -> void:
	for i in range(0, distribute_card_amount):
		var card : Card = draw_deck.draw_card()
		hand_cards.append(card)
#	card_distributed.emit(hand_cards)
	EventBus.emit("card_distributed", [hand_cards])
