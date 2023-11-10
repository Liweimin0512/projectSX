extends Control
class_name CardContainer

@onready var hand_card : W_HandCardContainer = %hand_card
@onready var draw_deck : W_Deck = %draw_deck
@onready var discard_deck : W_Deck = %discard_deck
@onready var arrow :Node2D = $bessel_arrow

var card_remove_index := 0

var _controller : C_CardSystem

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	_controller = GameInstance.player.get_component("C_CardSystem")
##	card_preview.pivot_offset = Vector2(card_preview.size.x/2,card_preview.size.y)
##	card_preview.hide()
#	_controller.card_distributed.connect(
#		func(cards: Array) -> void:
#			draw_card(cards)
#	)
	EventBus.subscribe("card_distributed", _on_card_distributed)

## 抽卡
func draw_card(card: Card) -> void:
	hand_card.add_card(card)
	card.global_position = draw_deck.global_position








func _on_card_distributed(cards: Array) -> void:
	for card in cards:
		draw_card(card)

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
		reset_highlight()
	if event is InputEventMouseMotion and is_dragging:
		if card.needs_target():
			# 如果需要选择目标，则显示贝塞尔曲线或其他目标选择指示器
			print("需要选择目标")
		else:
			# 如果不需要选择目标，则直接随着拖动移动卡牌
#			card.global_position = event.position
			card.global_position += event.relative
	if event is InputEventMouseButton and event.is_released():
		is_dragging = false
		if event.global_position.y < get_viewport_rect().size.y * 2/3:
			if can_card_release(card):
				await release_card(card)
			else:
				_update_card_positions()
		else:
			# 返回卡牌到原始位置
			_update_card_positions()
