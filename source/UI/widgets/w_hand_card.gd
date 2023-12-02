extends Container
class_name W_HandCard

## 动效的时间
@export var tween_speed : float = 0.05
@export var offset_x_proportion : float = 0.6
## 手中最大牌数限制
@export var max_num_cards: int = 12
@export var rotation_proportion:float = 5

var highlighted_card : W_Card
var is_dragging: bool = false

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)

func _on_child_entered_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.connect(_on_card_mouse_exited.bind(node))
	node.gui_input.connect(_on_card_gui_input.bind(node))
	_update_card_positions()

func _on_child_exiting_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.disconnect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.disconnect(_on_card_mouse_exited.bind(node))
	node.gui_input.disconnect(_on_card_gui_input.bind(node))
	_update_card_positions()

## 突出显示一个卡牌，使其与其他卡牌分开
func highlight_card(w_card: W_Card) -> void:
	# 放大被悬停的卡牌
	w_card.scale = 2 * Vector2.ONE
	# 根据需要重新排列卡牌，例如将悬停的卡牌移到前面
	w_card.z_index = 1
	# 记录突出显示的卡牌
	highlighted_card = w_card

## 取消突出显示的卡牌
func reset_highlight(w_card: W_Card) -> void:
	assert(w_card == highlighted_card, "取消突出显示的卡牌和高亮卡牌不一致！")
	if highlighted_card:
		highlighted_card.scale = Vector2.ONE
		highlighted_card.z_index = 0
		highlighted_card = null

func _get_card_position(index) -> Vector2:
	return Vector2.ZERO

func _get_card_rotation(index) -> float:
	return 0

## 更新所有卡牌的位置、旋转和大小，以实现扇形效果
func _update_card_positions():
	var hand_cards = self.get_children()
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

func _on_card_gui_input(event:InputEvent, w_card: W_Card) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		is_dragging = true
#		dragging_start_position = event.position
		card_selected.emit(w_card)
		reset_highlight()
	if event is InputEventMouseMotion and is_dragging:
		if not can_card_release(w_card):
			push_warning("不可释放，直接不让拖拽")
			return
		if w_card.needs_target():
			# 如果需要选择目标，则显示贝塞尔曲线或其他目标选择指示器
			selected_card = w_card
			find_target()
		else:
			# 如果不需要选择目标，则直接随着拖动移动卡牌
#			card.global_position = event.position
			w_card.global_position += event.relative
	if event is InputEventMouseButton and event.is_released():
		is_dragging = false
		if selected_card:
			if _combat_scene.cha_selected and can_card_release(w_card):
				release_card(w_card, _combat_scene.cha_selected)
				card_unselected.emit(w_card)
#			else:
#				selected_card = null
#				_update_card_positions()
		elif event.global_position.y < get_viewport_rect().size.y * 2/3:
			if can_card_release(w_card):
				await release_card(w_card, null)
			else:
				_update_card_positions()
			card_unselected.emit(w_card)
		else:
			# 返回卡牌到原始位置
			_update_card_positions()
			card_unselected.emit(w_card)

func _on_card_mouse_entered(w_card: W_Card) -> void:
	if is_dragging: return
	highlight_card(w_card)

func _on_card_mouse_exited(w_card: W_Card) -> void:
	reset_highlight(w_card)
