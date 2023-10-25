extends Node

## 手牌
var hand_cards : Array[Card] = []

## 默认每回合可抽取5张卡牌
var distribute_card_amount := 5

var discard_deck: CardDeck = CardDeck.new("弃牌堆", 0)
var draw_deck: CardDeck = CardDeck.new("抽牌堆", 1)

signal card_distributed

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
		var card = draw_deck.draw_card()
		hand_cards.append(card)
		card_distributed.emit(card)
