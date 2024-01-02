extends MarginContainer
class_name W_Deck

@onready var deck_icon: TextureRect = %deck_icon
@onready var lab_card_amount: Label = %lab_card_amount

## 牌堆的类型，需要开发者手动设置
@export var deck_type: CardDeckModel.DECK_TYPE
## 逻辑层牌堆的引用
var _deck: CardDeck
## 卡牌数量
var card_amount: int :
	get:
		return _deck.get_card_amount()

## 牌堆按下信号
signal pressed

func _ready() -> void:
	var c_card_sytem: C_CardSystem = GameInstance.player.get_node("C_CardSystem")
	_deck = c_card_sytem.get_deck(deck_type)
	_deck.cards_changed.connect(_on_card_changed)
	self.gui_input.connect(_on_gui_input)
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	deck_icon.pivot_offset = deck_icon.size / 2
	_update_display()

## 更新显示
func _update_display() -> void:
	lab_card_amount.text = str(card_amount)

## 添加卡牌(Add Card)：将卡牌添加到牌组中。
func _on_card_changed() -> void:
	_update_display()

## 在gui_input信号链接方法中检测鼠标左键的按下（松开按键）
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			pressed.emit()

## 鼠标进入反馈
func _on_mouse_entered() -> void:
	deck_icon.scale *= 1.5

## 鼠标退出反馈
func _on_mouse_exited() -> void:
	deck_icon.scale = Vector2.ONE

## 覆盖tooltip显示方法，自定义tooltip控件
func _make_custom_tooltip(for_text: String) -> Object:
	var w_tooltip = load("res://source/UI/widgets/w_tooltip.tscn").instantiate()
	w_tooltip.set_tooltip(_deck.deck_name, "在每回合开始时，你从这里抽5张牌，点击查看你抽牌堆中的牌（但顺序是打乱的）")
	return w_tooltip

## 重写获取名称时候的输出
func _to_string() -> String:
	return _deck.deck_name
