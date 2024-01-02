extends RefCounted
class_name CardDeck

var _model : CardDeckModel

## 牌库名
var deck_name: String :
	get = _deck_name_getter,
	set = _readonly
## 牌库描述
var deck_des: String:
	get = _deck_des_getter,
	set = _readonly
## 牌库列表
var cards: Array[Card]:
	get = _cards_getter,
	set = _readonly

## 牌库的卡牌发生改变
signal cards_changed

func _init(d_name: String, type: int, des: String) -> void:
	_model = CardDeckModel.new(d_name, type, des)

## 设置cards
func set_cards(cards: Array[Card]) -> void:
	_model.card_list = cards
	cards_changed.emit()

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func add_card(card: Card) -> void:
	_model.card_list.append(card)
	cards_changed.emit()

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func remove_card(card: Card) -> void:
	_model.card_list.erase(card)
	cards_changed.emit()

## 清空cards
func clear_cards() -> void:
	_model.card_list.clear()
	cards_changed.emit()

## 洗牌(Shuffle)：将牌组中的卡牌重新洗牌。
func shuffle() -> void:
	_model.card_list.shuffle()

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func draw_card() -> Card:
	shuffle()
	var card : Card = _model.card_list.pop_front()
	cards_changed.emit()
	return card

## 获取全部卡牌
func get_card_list() -> Array:
	return _model.card_list

## 获取卡牌数量
func get_card_amount() -> int:
	return _model.card_list.size()

func _readonly(value) -> void:
	assert(false, "尝试给只读属性赋值！")
func _cards_getter() -> Array:
	return _model.card_list
func _deck_name_getter() -> String:
	return _model.deck_name
func _deck_des_getter() -> String:
	return _model.deck_des
