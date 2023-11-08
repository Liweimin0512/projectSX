extends RefCounted
class_name CardDeck

var _model : CardDeckModel

signal card_added
signal card_removed
signal shuffled
signal drawed

func _init(d_name: StringName, type: int) -> void:
	_model = CardDeckModel.new(d_name, type)

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func add_card(card: Entity) -> void:
	_model.card_list.append(card)
	card_added.emit()

## 移除卡牌(Remove Card)：从牌组中移除卡牌。
func remove_card(card: Entity) -> void:
	_model.card_list.erase(card)
	card_removed.emit()

## 洗牌(Shuffle)：将牌组中的卡牌重新洗牌。
func shuffle() -> void:
	_model.card_list.shuffle()
	shuffled.emit()

## 抽牌(Draw Card)：从牌组中抽取卡牌。
func draw_card() -> Entity:
	shuffle()
	var card : Entity = _model.card_list.pop_front()
	drawed.emit(card)
	return card

func get_card_amount() -> int:
	return _model.card_list.size()
