extends Control

## 卡牌的父节点
@onready var grid_container: GridContainer = %GridContainer
## 牌堆名
@onready var label_name: Label = %label_name
## 牌堆描述
@onready var label: Label = %Label
## 返回按钮
@onready var btn_close: Button = %btn_close
## 牌堆的引用，w_card_manager显示牌堆详情页前会赋值
var _w_deck: W_Deck

func _ready() -> void:
	self.visibility_changed.connect(_on_visibility_changed)
	btn_close.pressed.connect(_on_btn_close_pressed)
	self.hide()

func _on_visibility_changed() -> void:
	if not _w_deck : return
	if self.visible == true:
		_on_show()
	else:
		_on_hide()

## 显示时逻辑处理
func _on_show() -> void:
	var _deck: CardDeck = _w_deck._deck
	label_name.text = _deck.deck_name
	label.text = _deck.deck_des
	_w_deck.z_index = 1
	var card_list = _deck.get_card_list()
	card_list.sort_custom(
		func(a, b): 
			return a.card_name.naturalnocasecmp_to(b.card_name) < 0
	)
	for card in card_list:
		var w_card: W_Card = W_CardManager.create_card_widget(card)
		grid_container.add_child(w_card)
		w_card.pivot_offset = w_card.size / 2
		w_card.mouse_entered.connect(
			func() -> void:
				w_card.scale *= 1.5
				w_card.z_index = 1
				w_card.preview()
		)
		w_card.mouse_exited.connect(
			func() -> void:
				w_card.scale = Vector2.ONE
				w_card.z_index = 0
				w_card.cancel_preview()
		)	

## 隐藏时处理
func _on_hide() -> void:
		_w_deck.z_index = 0

## 玩家点击返回按钮隐藏自身
func _on_btn_close_pressed() -> void:
	for card in grid_container.get_children():
		card.queue_free()
	self.hide()
