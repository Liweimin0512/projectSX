extends Node
class_name C_CardSystem

## 分发卡牌数量
@export var distribute_card_amount: int = 4
## 抽牌堆
var draw_deck : CardDeck = CardDeck.new("抽牌堆", 0, "每个回合结束的时候都从这里抽牌")
## 弃牌堆
var discard_deck: CardDeck = CardDeck.new("弃牌堆", 1, "每个回合结束的时候都会将手牌丢弃在这里")
## 手牌
var hand_cards : Array[Card] = []
## 牌堆
var _deck : Array[Card] = []

var selected_cha: Character = null:
	set(value):
		if selected_cha:
			selected_cha.unselected()
		selected_cha = value
		if selected_cha:
			selected_cha.selected()
		selected_cha_changed.emit(selected_cha)
var target_selector: TargetSelector = null

signal card_distributed
signal card_drawn(card: Card)
signal card_released(card: Card)
signal card_discarded(card: Card)
signal draw_deck_replenished
signal selected_cha_changed(cha: Character)

func init(playerID: StringName) -> void:
	var initial_deck: Array = DatatableManager.get_datatable_row("hero", playerID)["initial_deck"]
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			var card: Card = Card.new(card_id)
			_deck.append(card)
			draw_deck.add_card(card)

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

## 弃牌
func discard_card(card_index: int) -> void:
	var card = hand_cards.pop_at(card_index)
	card_discarded.emit(card)
	discard_deck.add_card(card)

## 分发卡牌(Distribute Card)：在游戏开始或特定事件时分发卡牌给玩家。
func distribute_card() -> void:
	for i in range(0, distribute_card_amount):
		draw_card()
	card_distributed.emit(hand_cards)

## 重置抽牌堆
func replenish_draw_deck():
	discard_deck.shuffle()
	draw_deck.cards = discard_deck.cards.duplicate()
	discard_deck.cards.clear()
	draw_deck_replenished.emit()

# 检查玩家能量是否足够释放卡牌
func can_release_card(card: Card) -> bool:
	if not selected_cha:
		push_warning("当前没有选中角色，无法释放卡牌！")
		return false
	return card.can_release(owner)

## 预释放卡牌
func prerelease_card(card: Card) -> void:
	if card.needs_target():
		target_selector = TargetSelector.new({"cha_type":"Enemy"})
		target_selector.target_selected.connect(
			func(cha: Character) -> void:
				selected_cha = cha
		)
		target_selector.selection_canceled.connect(
			func() -> void:
				selected_cha = null
		)
	else:
		selected_cha = owner

## 释放卡牌：释放卡牌技能
func release_card(card: Card) -> void:
	if not can_release_card(card):
		push_warning("能量不足，无法释放卡牌！")
		return
	card.release(owner, selected_cha)
	hand_cards.erase(card)
	discard_deck.add_card(card)
	target_selector = null
	selected_cha = null
	card_released.emit(card)

## 根据牌库类型获取牌库
func get_deck(dect_type: CardDeckModel.DECK_TYPE) -> CardDeck:
	match  dect_type:
		CardDeckModel.DECK_TYPE.DRAW:
			return draw_deck
		CardDeckModel.DECK_TYPE.DISCARD:
			return discard_deck
		_:
			push_error("未找到指定的牌堆类型")
			return null

## 丢弃所有手牌
func discard_all() -> void:
	for card in hand_cards:
		discard_deck.add_card(card)
		card_discarded.emit(card)
	hand_cards.clear()
