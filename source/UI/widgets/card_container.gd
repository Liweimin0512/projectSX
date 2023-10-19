extends Control
class_name CardContainer

## 卡牌偏移量
@export var offset_x_proportion : float = 0.4
@export var rotation_proportion: float = 5
@export var tween_speed : float = 0.2
@export var hand_card_position : Vector2 = Vector2(480,510)

@onready var t_card_view : PackedScene = preload("res://source/widgets/cards/card_view.tscn")

@onready var hand_card : Control = %hand_card
@onready var draw_deck : Control = %draw_deck
@onready var discard_deck : Control = %discard_deck
@onready var arrow :Node2D = $bessel_arrow

@onready var max_card_amount : int = 12

var card_remove_index := 0

var cards : Array : 
	get : return hand_card.get_children()
var card_amount : int = 0
var offset_x

var dragging = false
var click_pisition
var selected_card: Card = null:
	set(value):
		update_card_position()
		if value:
			var tween: Tween = create_tween()
			tween.set_parallel()
#			tween.tween_property(value, "position", target_position, tween_speed)
			tween.tween_property(value, "rotation_degrees", 0, tween_speed)
			tween.tween_property(value, "scale", Vector2.ONE * 2, tween_speed)
			value.z_index = 64
		selected_card = value
		

var can_release_card : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
#	card_preview.pivot_offset = Vector2(card_preview.size.x/2,card_preview.size.y)
#	card_preview.hide()
	for c in cards:
		c.queue_free()
	for i in range(0, 5):
		var card : CardView = t_card_view.instantiate()
		hand_card.add_child(card)
		card.card_mouse_entered.connect(_on_card_mouse_entered.bind(card))
		card.card_mouse_exited.connect(_on_card_mouse_exited.bind(card))
		printerr(card.rotation)
	update_card_position()

func _process(delta):
	if dragging and selected_card != null:
			# _on_card_dragging(selected_card)
			if selected_card.is_all_target():
				_on_card_dragging(selected_card)
				if get_viewport_rect().size.y * 0.8 > get_viewport().get_mouse_position().y:
					selected_card.prerelease()
				else:
					selected_card.predragging()
			else:
				# 否则，不拖拽，显示选择目标的箭头曲线
				arrow.reset(click_pisition,get_viewport().get_mouse_position())
				# selected_card.card.hide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not dragging and event.pressed:
			dragging = true
			click_pisition =  event.position
			if selected_card !=  null and selected_card.is_all_target():
				if selected_card.card_state == selected_card.CardState.normal:
					selected_card.predragging()
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			arrow.hide()
			# 松开鼠标按键，判断是否可释放
			dragging = false
			if selected_card:
				if selected_card.is_all_target():
					if selected_card.can_release:
						selected_card.release()
					else:
						selected_card.predragging()
				else:
					pass 
				selected_card = null
			update_card_position()

## 将每个卡牌归位
func update_card_position():
	if cards.size() == 0:
		return
	card_amount = cards.size()
	offset_x = cards[0].size.x ## 单卡偏移量
	for i in cards.size():
		var card : Card = cards[i]
		card.z_index = 0
		var card_offset = card_amount * -0.5 + 0.5 + 1 * i
		card.pivot_offset = Vector2(
			cards[i].size.x/2,
			cards[i].size.y
			)
		var target_position = Vector2(card_offset * offset_x * offset_x_proportion * (1 if card_amount <= max_card_amount else max_card_amount/card_amount) , 0) 
		var target_rotation = card_offset * rotation_proportion
		var target_scale = Vector2(1,1)
#		assert(tween, '没找到 tween')
		var tween : Tween = create_tween()
		tween.set_parallel()
		print("rotation_degress:", target_rotation)
		tween.tween_property(card, "position", target_position, tween_speed)
		tween.tween_property(card, "rotation_degrees", target_rotation, tween_speed)
		tween.tween_property(card, "scale", target_scale, tween_speed)
#		tween.play()
#		card.rotation = i * rotation_proportion
#		printerr("card rotation: ", card.rotation, "i: ", i, "rotation_proportion: ", rotation_proportion)
		if card.card_manager != self:
			card.card_manager = self
		# cards[i].card_state = cards[i].CardState.normal
		card.card.show()

## 添加卡牌
func add_cards(n:int):
	for i in range(n):
		var card = t_card_view.instantiate()
		hand_card.add_child(card)
		card.scale = Vector2.ZERO
		card.position = draw_deck.position - hand_card.position
		update_card_position()

## 删除卡牌
func remove_card(card):
	if cards.size() == 0:
		return
	var tween : Tween = create_tween()
	var target_position = discard_deck.position - hand_card.position
	tween.set_parallel()
	tween.tween_property(card, "position", target_position, tween_speed)
	tween.tween_property(card, "scale", Vector2.ZERO, tween_speed)
	await tween.finished
	hand_card.remove_child(card)
	card.queue_free()
	update_card_position()

#########################################

func _on_card_dragging(card):
	if card.card_state == card.CardState.preview:
		# 如果当前是预览状态，需要还原一下
		card.preview()
	card.rotation = 0
	card.scale = Vector2(1.2,1.2)
	card.position = get_viewport().get_mouse_position() - hand_card.position

func _on_card_mouse_entered(card: Card) -> void:
	if selected_card != null:
		return
	selected_card = card
	print("_on_card_mouse_entered:", card)

func _on_card_mouse_exited(card: Card) -> void:
	if selected_card == card:
		selected_card = null
	print("_on_card_mouse_exited:", card)

func _on_btn_add_card_pressed():
	add_cards(2)

func _on_btn_remove_card_pressed():
	card_remove_index = 1
	remove_card(cards[card_remove_index])
