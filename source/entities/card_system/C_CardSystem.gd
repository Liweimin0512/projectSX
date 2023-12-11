extends Node
class_name C_CardSystem

var distribute_card_amount: int = 5
var draw_deck : CardDeck = CardDeck.new("抽牌堆", 0, "每个回合结束的时候都从这里抽牌")
var discard_deck: CardDeck = CardDeck.new("弃牌堆", 1, "每个回合结束的时候都会将手牌丢弃在这里")
var hand_cards : Array = []
var initial_deck: Array

#signal card_distributed
signal card_drawn(card: Card)
signal card_released(card: Card)
signal card_discarded(card: Card)
signal draw_deck_replenished

func component_init(playerID: StringName) -> void:
	initial_deck = DatatableManager.get_datatable_row("hero", playerID)["initial_deck"]
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			draw_deck.add_card(create_card(card_id))

## 创建卡牌(Create Card)：根据指定的参数创建新卡牌。
func create_card(cardID : StringName) -> Card:
	var card: Card = Card.new(cardID)
	#card.cardID = cardID
	return card

## 升级卡牌(Upgrade Card)：升级指定的卡牌。
func upgrade_card() -> void:
	pass

## 抽牌
func draw_card() -> Card:
	var card = draw_deck.draw_card()
	if card == null and not discard_deck.get_card_list().is_empty():
		replenish_draw_deck()
		card = draw_deck.draw_card()
	# 处理抽到的卡牌，比如添加到手牌
	if card:
		hand_cards.append(card)
		card_drawn.emit(card)
	return card

func replenish_draw_deck():
	discard_deck.shuffle()
	draw_deck.cards = discard_deck.cards.duplicate()
	discard_deck.cards.clear()
	draw_deck_replenished.emit()

## 分发卡牌(Distribute Card)：在游戏开始或特定事件时分发卡牌给玩家。
func distribute_card() -> void:
	for i in range(0, distribute_card_amount):
		draw_card()
	#card_distributed.emit(hand_cards)

## 释放卡牌：释放卡牌技能
func release_card(card: Card, selected_cha: Character = null) -> void:
	if not can_release_card(card, selected_cha):
		push_warning("能量不足，无法释放卡牌！")
		return
	card.release(owner, selected_cha)
	hand_cards.erase(card)
	card_released.emit(card)
	discard_deck.add_card(card)

# 检查玩家能量是否足够释放卡牌
func can_release_card(card: Card, selected_cha: Character) -> bool:
	return card.can_release(owner)

func get_deck(dect_type: CardDeckModel.DECK_TYPE) -> CardDeck:
	match  dect_type:
		CardDeckModel.DECK_TYPE.DRAW:
			return draw_deck
		CardDeckModel.DECK_TYPE.DISCARD:
			return discard_deck
		_:
			push_error("未找到指定的牌堆类型")
			return null

## 丢弃卡牌
func discard_card(card_index: int) -> void:
	var card = hand_cards.pop_at(card_index)
	card_discarded.emit(card)
	discard_deck.add_card(card)

## 丢弃所有手牌
func discard_all() -> void:
	for card in hand_cards:
		discard_deck.add_card(card)
		card_discarded.emit(card)
	hand_cards.clear()
