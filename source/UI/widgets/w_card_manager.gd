extends Control
class_name CardContainer

@onready var draw_deck : W_Deck = %draw_deck
@onready var discard_deck : W_Deck = %discard_deck
@onready var bezier_arrow :Node2D = %bezier_arrow
#@onready var w_card_list: Control = %w_card_list
@onready var w_hand_card: Control = %W_HandCard

var drag_card: W_Card = null:
	set(value):
		drag_card = value
		if drag_card != null:
			drag_card.scale = Vector2.ONE * 1.3
			drag_card.rotation = 0
			drag_card.z_index = 128
		else:
			w_hand_card.update_card_layout()
			bezier_arrow.hide()
var drag_position : Vector2

## 战斗场景引用
var _combat_scene : CombatScene 
## 卡牌管理器的引用
var _card_system : C_CardSystem

# combat_scene需要获取这个事件禁用下回合按钮
signal card_selected(card: Card)
signal card_unselected(card: Card)

func _ready() -> void:
	_card_system = GameInstance.player.get_node("C_CardSystem")
	_combat_scene = SceneManager.current_scene
	_card_system.card_drawn.connect(_on_card_drawn)
	_card_system.card_released.connect(_on_card_released)
	_card_system.card_discarded.connect(_on_card_discarded)
	draw_deck.pressed.connect(_on_deck_pressed.bind(draw_deck))
	discard_deck.pressed.connect(_on_deck_pressed.bind(discard_deck))
	_card_system.draw_deck_replenished.connect(
		func():
			draw_deck.update_display()
			discard_deck.update_display()
	)

## 能否释放卡牌
func can_release_card(w_card: W_Card) -> bool:
	# 判断鼠标位置是否在屏幕下方（手牌区域）
	if w_card.needs_target() and _combat_scene.cha_selected == null:
		return false
	return _card_system.can_release_card(w_card.card)

## 释放卡牌
func release_card(w_card: W_Card, target: Character) -> void:
	var card = w_card.card
	_card_system.release_card(card, [target])

## 寻找目标
func found_target() -> void:
	if not drag_card: return
	if _combat_scene.cha_selected:
		bezier_arrow.selected()
	else:
		bezier_arrow.unselected()
	bezier_arrow.reset(w_hand_card.global_position, get_global_mouse_position())

## 抽牌时候的表现效果处理
func _on_card_drawn(card: Card) -> void:
	var w_card : W_Card = create_card_widget(card)
	w_hand_card.add_card(w_card, draw_deck.global_position)
	w_card.drag_started.connect(_on_w_card_drag_started.bind(w_card))

## 卡牌释放的信号处理
func _on_card_released(card: Card) -> void:
	bezier_arrow.hide()
	w_hand_card.remove_card(card, discard_deck.global_position)

## 卡牌被丢弃时候的信号处理
func _on_card_discarded(card: Card) -> void:
	w_hand_card.remove_card(card, discard_deck.global_position)

func _on_deck_pressed(w_deck: W_Deck) -> void:
	print("_on_deck_pressed", w_deck)

## 创建卡牌控件
func create_card_widget(card: Card) -> W_Card:
	var w_card : W_Card = preload("res://source/UI/widgets/w_card.tscn").instantiate()
	w_card.card = card
	return w_card

func _on_w_card_drag_started(at_position : Vector2, w_card: W_Card) -> void:
	print("_on_w_card_drag_started:", w_card, at_position)
	drag_position = at_position
	drag_card = w_card

func _unhandled_input(event: InputEvent) -> void:
	if not drag_card or not drag_card.can_drag(): return
	if event is InputEventMouseMotion:
		if drag_card.needs_target():
			found_target()
		else:
			drag_card.global_position = event.global_position
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released():
			# 此时如果是选择目标状态，则选择目标
			if can_release_card(drag_card):
				release_card(drag_card, _combat_scene.cha_selected)
			drag_card = null
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		#if event.is_pressed():
			## 此时是选择目标状态，则退出选择状态
			#unselected_card()
			#bezier_arrow.hide()
