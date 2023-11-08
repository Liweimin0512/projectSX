extends Control
class_name W_HandCardContainer

## 存储手牌的数组
var cards : Array = []
## 动效的时间
@export var tween_speed : float = 0.2

@export var offset_x_proportion : float = 0.8
## 手中最大牌数限制
@export var max_num_cards: int = 12

var tween : Tween

# 被突出显示的卡牌
var highlighted_card: CardView = null

var is_dragging = false
#var dragging_start_position : Vector2

## 当添加了一张新的卡片时发出
signal card_added(card: CardView)
## 当一张卡片被移除时发出
signal card_removed(card: CardView)

## 向手牌中添加卡牌
func add_card(w_card: CardView) -> void:
	# 首先，将新卡牌添加到容器和卡牌数组中
	add_child(w_card)
	cards.append(w_card)
	# 然后，更新所有卡牌的位置
	_update_card_positions()
	w_card.mouse_entered.connect(_on_card_mouse_entered.bind(w_card))
	w_card.mouse_exited.connect(_on_card_mouse_exited.bind(w_card))
	w_card.gui_input.connect(_on_card_gui_input.bind(w_card))
	# 您可以在此添加其他与添加卡牌相关的逻辑，例如播放音效等。

## 从手牌中移除卡牌
func remove_card(w_card: CardView) -> void:
	if not w_card in cards:
		return
	cards.erase(w_card)
	remove_child(w_card)
	_update_card_positions()
	w_card.mouse_entered.disconnect(_on_card_mouse_entered.bind(w_card))
	w_card.mouse_exited.disconnect(_on_card_mouse_exited.bind(w_card))
	w_card.gui_input.disconnect(_on_card_gui_input.bind(w_card))

## 更新所有卡牌的位置、旋转和大小，以实现扇形效果
func _update_card_positions() -> void:
	var num_cards = cards.size()
	if num_cards == 0 : return # 没有手牌直接返回
	var offset_x = cards[0].size.x * offset_x_proportion * min(1, max_num_cards/ num_cards) ## 单卡偏移量
	for i in num_cards:
		var card : CardView = cards[i]
		var card_offset = num_cards * -0.5 + 0.5 + 1 * i
		var target_position : Vector2 = Vector2(
			card_offset * offset_x,
			0
		)
		card.pivot_offset = Vector2(card.size.x/2, card.size.y)
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(card, "position", target_position, tween_speed)
		await tween.finished
	
## 突出显示一个卡牌，使其与其他卡牌分开
func highlight_card(card: CardView) -> void:
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
func can_card_release(card: CardView) -> bool:
	
	return card.can_release()

## 释放卡牌
func release_card(card: CardView) -> void:
	card.release()

func _on_card_mouse_entered(card: CardView) -> void:
	if is_dragging:
		return
	highlight_card(card)

func _on_card_mouse_exited(card: CardView) -> void:
	reset_highlight()

func _on_card_gui_input(event:InputEvent, card: CardView) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		print("选中卡牌")
		is_dragging = true
#		dragging_start_position = event.position
		reset_highlight()
	if event is InputEventMouseMotion and is_dragging:
		print("拖拽卡牌")
		if card.needs_target():
			# 如果需要选择目标，则显示贝塞尔曲线或其他目标选择指示器
			print("需要选择目标")
		else:
			# 如果不需要选择目标，则直接随着拖动移动卡牌
#			card.global_position = event.position
			card.global_position += event.relative
		print("窗口大小：", get_viewport_rect().size)
	if event is InputEventMouseButton and event.is_released():
		print("释放卡牌")
		is_dragging = false
		if event.global_position.y < get_viewport_rect().size.y * 2/3:
			if can_card_release(card):
				release_card(card)
			else:
				_update_card_positions()
		else:
			# 返回卡牌到原始位置
			_update_card_positions()
