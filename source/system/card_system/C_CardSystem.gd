extends Node
class_name C_CardSystem

## 牌库，代表拥有者拥有的所有卡牌
var _cards : Array[Card] = []
## 分发卡牌数量
@export var distribute_card_amount: int = 4
## 抽牌堆
var draw_deck : CardDeck = CardDeck.new("抽牌堆", 0, "每个回合结束的时候都从这里抽牌")
## 弃牌堆
var discard_deck: CardDeck = CardDeck.new("弃牌堆", 1, "每个回合结束的时候都会将手牌丢弃在这里")
## 手牌
var hand_cards : Array[Card] = []
## 目标选择器
var target_selector: TargetSelector = null

signal card_distributed						# 卡牌分发
signal card_drawn(card: Card)				# 卡牌抽取
signal card_released(card: Card)			# 卡牌释放
signal card_discarded(card: Card)			# 卡牌丢弃
signal draw_deck_replenished				# 重置抽牌堆
signal selected_cha_changed(cha: Character)	# 选择目标改变

## 卡牌系统组件的初始化方法
func init(playerID: StringName) -> void:
	var initial_deck: Array = DatatableManager.get_datatable_row("hero", playerID)["initial_deck"]
	for i in range(0, initial_deck.size(), 2):
		var card_id: String = initial_deck[i]
		var card_amount :int= int(initial_deck[i+1])
		for a in card_amount:
			var card: Card = Card.new(card_id)
			add_card(card)

## 添加卡牌
func add_card(card: Card) -> void:
	_cards.append(card)
	card.caster = owner

## 移除卡牌
func remove_card(card: Card) -> void:
	_cards.erase(card)
	card.caster = null

## 升级卡牌(Upgrade Card)：升级指定的卡牌。
func upgrade_card() -> void:
	pass

## 初始化抽牌堆
func init_draw_deck() -> void:
	draw_deck.set_cards(_cards)

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

## 分发卡牌：在游戏开始或特定事件时分发卡牌给玩家。
func distribute_card() -> void:
	for i in range(0, distribute_card_amount):
		draw_card()
	card_distributed.emit(hand_cards)

## 重置抽牌堆
func replenish_draw_deck():
	discard_deck.shuffle()
	draw_deck.set_cards(discard_deck.cards.duplicate())
	discard_deck.clear_cards()
	draw_deck_replenished.emit()

# 检查玩家能量是否足够释放卡牌
func can_release_card(card: Card) -> bool:
	var selected_cha : Character
	if not card.needs_target():
		selected_cha = owner
	elif target_selector:
		selected_cha = target_selector.get_target()
	if not selected_cha:
		push_warning("当前没有选中角色，无法释放卡牌！")
		return false
	return card.can_release()

## 预释放卡牌
func prerelease_card(card: Card) -> void:
	if card.needs_target():
		#TODO 这里应该根据卡牌的目标类型传入参数
		target_selector = TargetSelector.new({"cha_type":"Enemy"})
		target_selector.target_changed.connect(_on_target_changed)

## 释放卡牌：释放卡牌技能
func release_card(card: Card) -> void:
	if not can_release_card(card):
		push_warning("能量不足，无法释放卡牌！")
		return
	var selected_cha : Character
	if not card.needs_target():
		selected_cha = owner
	elif target_selector.has_target():
		selected_cha = target_selector.get_target()
	if not selected_cha:
		push_warning("未选中目标，无法释放卡牌！")
		return
	card.release(owner, selected_cha)
	hand_cards.erase(card)
	discard_deck.add_card(card)
	target_selector = null
	selected_cha.unselected()
	card_released.emit(card)

## 取消释放卡牌
func cancel_release_card() -> void:
	if target_selector and target_selector._target_cha:
		target_selector._target_cha.unselected()
	target_selector.target_changed.disconnect(_on_target_changed)
	target_selector = null

## 弃牌
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

## 目标选择器目标改变处理函数
func _on_target_changed(old: Character, new: Character) -> void:
	if old:
		old.unselected()
	if new:
		new.selected()
	selected_cha_changed.emit(new)
