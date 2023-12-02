extends Control
class_name CardContainer

@onready var draw_deck : W_Deck = %draw_deck
@onready var discard_deck : W_Deck = %discard_deck
@onready var bezier_arrow :Node2D = %bezier_arrow
#@onready var w_card_list: Control = %w_card_list
@onready var w_hand_card: W_HandCard = %W_HandCard

#var card_remove_index := 0
#var tween : Tween

# 被突出显示的卡牌
var highlighted_card: W_Card = null

var is_dragging := false
var selected_card: W_Card = null:
	set(value):
		selected_card = value
		if selected_card:
			selected_card.global_position = w_hand_card.global_position
			selected_card.scale = Vector2.ONE * 1.3
			selected_card.rotation = 0
			selected_card.z_index = 128
		else:
			bezier_arrow.hide()

## 战斗场景引用
var _combat_scene : CombatScene 
## 卡牌管理器的引用
var _card_system : C_CardSystem

## 当添加了一张新的卡片时发出
#signal card_added(card: Card)
## 当一张卡片被移除时发出
#signal card_removed(card: Card)
#signal card_selected(card: Card)
#signal card_unselected(card: Card)

func _ready() -> void:
	_card_system = GameInstance.player.get_node("C_CardSystem")
	_combat_scene = SceneManager.current_scene
	#_card_system.card_distributed.connect(_on_card_distributed)
	_card_system.card_drawn.connect(_on_card_drawn)
	_card_system.card_released.connect(_on_card_released)
	_card_system.card_discarded.connect(_on_card_discarded)
	draw_deck.pressed.connect(_on_deck_pressed.bind(draw_deck))
	discard_deck.pressed.connect(_on_deck_pressed.bind(discard_deck))

func _unhandled_input(event: InputEvent) -> void:
	if not selected_card: return
	if event is InputEventMouseMotion:
		found_target()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released() and _combat_scene.cha_selected:
			# 此时如果是选择目标状态，则选择目标
			if _card_system.can_release_card(selected_card.card):
				release_card(selected_card, _combat_scene.cha_selected)
			else:
				# 如果不能释放，则重置状态
				unselected_card()
				# _update_card_positions()
			#card_unselected.emit(selected_card)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			# 此时是选择目标状态，则退出选择状态
			unselected_card()
			bezier_arrow.hide()
			# _update_card_positions()
			#card_unselected.emit(selected_card)

func selecte_card(w_card: W_Card) -> void:
	w_hand_card.remove_child(w_card)
	self.add_child(selected_card)
	selected_card = w_card

func unselected_card() -> void:
	self.remove_child(selected_card)
	w_hand_card.add_child(selected_card)
	selected_card = null

## 释放卡牌
func release_card(w_card: W_Card, target: Character) -> void:
	var card = w_card.card
	_card_system.release_card(card, [target])
	#var tween := create_tween()
	#tween.set_parallel(true)
	#tween.tween_property(card, "position", discard_deck.global_position, 0.5)
	#tween.tween_property(card, "scale", Vector2.ZERO, 0.5)
	#await tween.finished
	#hand_card.remove_child(card)

## 寻找目标
func found_target() -> void:
	if not selected_card: return
	if _combat_scene.cha_selected:
		bezier_arrow.selected()
	else:
		bezier_arrow.unselected()
	bezier_arrow.reset(w_hand_card.global_position, get_global_mouse_position())

## 抽牌时候的表现效果处理
func _on_card_drawn(card: Card) -> void:
	var w_card : W_Card = create_card_widget(card)
	w_card.global_position = draw_deck.global_position
	w_card.scale = Vector2.ZERO
	w_hand_card.add_child(w_card)
	#_update_card_positions()

## 卡牌释放的信号处理
func _on_card_released(card: Card) -> void:
	bezier_arrow.hide()
	discard_card(card)

## 卡牌被丢弃时候的信号处理
func _on_card_discarded(card: Card) -> void:
	discard_card(card)

## 丢弃卡牌
func discard_card(card: Card) -> void:
	assert(selected_card.card != card, "当前选中的卡牌和释放的卡牌数据不一致!")
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(card, "position", discard_deck.global_position, 0.5)
	tween.tween_property(card, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	#hand_card.remove_child()
	#_update_card_positions()
	selected_card.queue_free()

func _on_deck_pressed(w_deck: W_Deck) -> void:
	#w_card_list._deck = w_deck._deck
	#w_card_list.show()
	print("_on_deck_pressed", w_deck)

## 创建卡牌控件
func create_card_widget(card: Card) -> W_Card:
	var w_card : W_Card = preload("res://source/UI/widgets/w_card.tscn").instantiate()
	w_card.card = card
	return w_card
