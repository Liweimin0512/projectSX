extends Control
class_name CardContainer

@onready var hand_card : Control = %hand_card
@onready var draw_deck : W_Deck = %draw_deck
@onready var discard_deck : W_Deck = %discard_deck
@onready var bezier_arrow :Node2D = %bezier_arrow

var card_remove_index := 0


## 存储手牌的数组
#var cards : Array = []
## 动效的时间
@export var tween_speed : float = 0.05

@export var offset_x_proportion : float = 0.6
## 手中最大牌数限制
@export var max_num_cards: int = 12
@export var rotation_proportion:float = 5

var tween : Tween

# 被突出显示的卡牌
var highlighted_card: Card = null

var is_dragging := false
var selected_card: Card = null:
	set(value):
		selected_card = value
		if selected_card:
			selected_card.global_position = hand_card.global_position
			selected_card.scale = Vector2.ONE * 1.3
			selected_card.rotation = 0
			selected_card.z_index = 128
		else:
			bezier_arrow.hide()

## 战斗场景引用
var _combat_scene : CombatScene 
## 卡牌管理器的引用
var _card_system :C_CardSystem
## 当添加了一张新的卡片时发出
signal card_added(card: Card)
## 当一张卡片被移除时发出
signal card_removed(card: Card)
signal card_selected(card: Card)
signal card_unselected(card: Card)

func _ready() -> void:
	_card_system = GameInstance.player.get_node("C_CardSystem")
	_combat_scene = SceneManager.current_scene
	_card_system.card_distributed.connect(_on_card_distributed)
	_card_system.card_released.connect(_on_card_released)

func _unhandled_input(event: InputEvent) -> void:
	if not selected_card: return
	if event is InputEventMouseMotion:
		find_target()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_released() and _combat_scene.cha_selected:
			# 此时如果是选择目标状态，则选择目标
			if can_card_release(selected_card):
				release_card(selected_card, _combat_scene.cha_selected)
			else:
				selected_card = null
				_update_card_positions()
			card_unselected.emit(selected_card)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.is_pressed():
			# 此时是选择目标状态，则退出选择状态
			selected_card = null
			bezier_arrow.hide()
			_update_card_positions()
			card_unselected.emit(selected_card)

## 突出显示一个卡牌，使其与其他卡牌分开
func highlight_card(card: Card) -> void:
	# 放大被悬停的卡牌
	card.scale = 2 * Vector2.ONE
	# 根据需要重新排列卡牌，例如将悬停的卡牌移到前面
	card.z_index = 1
	# 记录突出显示的卡牌
	highlighted_card = card

## 取消突出显示的卡牌
func reset_highlight() -> void:
	if highlighted_card:
		highlighted_card.scale = Vector2.ONE
		highlighted_card.z_index = 0
		highlighted_card = null

## 能否释放卡牌
func can_card_release(card: Card) -> bool:
	return _card_system.can_release_card(card)

## 释放卡牌
func release_card(card: Card, target: Character) -> void:
	_card_system.release_card(card, [target])
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(card, "position", discard_deck.global_position, 0.5)
	tween.tween_property(card, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	hand_card.remove_child(card)

## 寻找目标
func find_target() -> void:
	if not selected_card: return
	if _combat_scene.cha_selected:
		bezier_arrow.selected()
	else:
		bezier_arrow.unselected()
	bezier_arrow.reset(hand_card.global_position, get_global_mouse_position())

func _on_card_distributed(cards: Array) -> void:
	for card in cards:
		hand_card.add_child(card)
		card.global_position = draw_deck.global_position
		# 首先，将新卡牌添加到容器和卡牌数组中
	#	cards.append(card)
		# 然后，更新所有卡牌的位置
		_update_card_positions()
		card.mouse_entered.connect(_on_card_mouse_entered.bind(card))
		card.mouse_exited.connect(_on_card_mouse_exited.bind(card))
		card.gui_input.connect(_on_card_gui_input.bind(card))
		# 您可以在此添加其他与添加卡牌相关的逻辑，例如播放音效等。

func _on_card_released(card: Card) -> void:
	selected_card = null
	bezier_arrow.hide()
	_update_card_positions()

func _on_card_mouse_entered(card: Card) -> void:
	if is_dragging:
		return
	highlight_card(card)

func _on_card_mouse_exited(card: Card) -> void:
	reset_highlight()

func _on_card_gui_input(event:InputEvent, card: Card) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		is_dragging = true
#		dragging_start_position = event.position
		card_selected.emit(card)
		reset_highlight()
	if event is InputEventMouseMotion and is_dragging:
		if not can_card_release(card):
			push_warning("不可释放，直接不让拖拽")
			return
		if card.needs_target():
			# 如果需要选择目标，则显示贝塞尔曲线或其他目标选择指示器
			selected_card = card
			find_target()
		else:
			# 如果不需要选择目标，则直接随着拖动移动卡牌
#			card.global_position = event.position
			card.global_position += event.relative
	if event is InputEventMouseButton and event.is_released():
		is_dragging = false
		if selected_card:
			if _combat_scene.cha_selected and can_card_release(card):
				release_card(card, _combat_scene.cha_selected)
				card_unselected.emit(card)
#			else:
#				selected_card = null
#				_update_card_positions()
		elif event.global_position.y < get_viewport_rect().size.y * 2/3:
			if can_card_release(card):
				await release_card(card, null)
			else:
				_update_card_positions()
			card_unselected.emit(card)
		else:
			# 返回卡牌到原始位置
			_update_card_positions()
			card_unselected.emit(card)

## 更新所有卡牌的位置、旋转和大小，以实现扇形效果
func _update_card_positions():
	var hand_cards = hand_card.get_children()
	if hand_cards.size() == 0: return
	var card_amount = hand_cards.size()
	var offset_x = hand_cards[0].get_offset_x()
	for i in hand_cards.size():
		var card : Card = hand_cards[i]
		var card_offset = card_amount * -0.5 + 0.5 + 1 * i
		card.z_index = 0
#		card.pivot_offset = Vector2(card.size.x/2, card.size.y)
		# 位置偏移
#		card.position.x = card_offset * offset_x * offset_x_proportion
#		printerr(" card position x: ", card.position.x, " card_offset: ", card_offset, \
#			" offset_x_proportion: ", offset_x_proportion, " offset_x: ", offset_x)
		# 旋转偏移
		# cards[i].rotation = card_offset * rotation_proportion
		var target_position = Vector2(
			card_offset * offset_x * offset_x_proportion * (1 if card_amount <= max_num_cards else max_num_cards/card_amount) ,
			0
		) 
		var target_rotation = card_offset * rotation_proportion
#		assert(tween, '没找到 tween')
		var tween : Tween = create_tween()
		tween.tween_property(card, "position", target_position, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(card, "rotation_degrees", target_rotation, tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(card, "scale", Vector2(1,1), tween_speed).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		await tween.finished
