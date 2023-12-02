extends RefCounted
class_name CardDeck

var _model : CardDeckModel

var deck_name: String :
	get:
		return _model.deck_name
var deck_des: String:
	get:
		return _model.deck_des

signal card_added
signal card_removed
signal shuffled
signal card_drawed

func _init(d_name: String, type: int, des: String) -> void:
	_model = CardDeckModel.new(d_name, type, des)

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func add_card(card: Card) -> void:
	_model.card_list.append(card)
	card_added.emit(card)

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func remove_card(card: Card) -> void:
	_model.card_list.erase(card)
	card_removed.emit(card)

## 洗牌(Shuffle)：将牌组中的卡牌重新洗牌。
func shuffle() -> void:
	_model.card_list.shuffle()
	shuffled.emit()

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func draw_card() -> Card:
	shuffle()
	var card : Card = _model.card_list.pop_front()
	card_drawed.emit(card)
	return card

## 获取全部卡牌
func get_card_list() -> Array:
	return _model.card_list

## 获取卡牌数量
func get_card_amount() -> int:
	return _model.card_list.size()
