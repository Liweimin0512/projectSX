extends Container
class_name W_HandCard

## 动效的时间
@export var tween_speed : float = 0.05
@export var offset : Vector2 = Vector2.ZERO
## 手中最大牌数限制
@export var max_num_cards: int = 12
@export var rotation_proportion:float = 5

var highlighted_card : W_Card
#var is_dragging: bool = false

# 手牌布局参数
@export var radius: float = 200.0
@export var max_angle: float = 60.0  # 最大扇形角度

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)

## 添加卡牌到手牌中
func add_card(w_card: W_Card, start_position: Vector2) -> void:
	w_card.global_position = start_position
	w_card.scale = Vector2.ZERO
	self.add_child(w_card)

## 移除卡牌从手牌中
func remove_card(card: Card, end_position: Vector2) -> void:
	var w_card = _get_card_widget(card)
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(w_card, "global_position", end_position, 0.3)
	tween.tween_property(w_card, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	w_card.queue_free()

func update_card_layout() -> void:
	_update_hand_layout()

# 更新手牌布局
func _update_hand_layout():
	var card_count: int = get_child_count()
	var tween : Tween = create_tween()
	for i in range(card_count):
		var card : W_Card = get_child(i)
		var angle: float = _calculate_card_angle(i, card_count)
		var position: Vector2 = _calculate_card_position(angle)
		tween.set_parallel()
		tween.tween_property(card, "rotation_degrees", angle, tween_speed)
		tween.tween_property(card, "position", position, tween_speed)
		tween.tween_property(card, "scale", Vector2.ONE, tween_speed)
		tween.set_parallel(false)
		card.size = card.custom_minimum_size
		card.pivot_offset = Vector2(card.size.x/2, card.size.y)
		#card.scale = Vector2.ONE
	await tween.finished

# 计算每张卡牌的角度
func _calculate_card_angle(card_index: int, card_count: int) -> float:
	var spread: float = min(max_angle, card_count * 10.0)  # 扩散角度
	return lerp(-spread / 2, spread / 2, card_index / float(card_count - 1))

# 计算卡牌的位置
func _calculate_card_position(angle: float) -> Vector2:
	var radian = deg_to_rad(angle)
	return Vector2(sin(radian), -cos(radian)) * radius + offset

func _on_child_entered_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.connect(_on_card_mouse_exited.bind(node))
	#node.gui_input.connect(_on_card_gui_input.bind(node))
	_update_hand_layout()

func _on_child_exiting_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.disconnect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.disconnect(_on_card_mouse_exited.bind(node))
	#node.gui_input.disconnect(_on_card_gui_input.bind(node))
	_update_hand_layout()

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

## 根据卡牌逻辑层获取表现层
func _get_card_widget(card: Card) -> W_Card:
	var w_card = self.get_children().filter(
		func(w_card) :
			return w_card.card == card
	)[0]
	return w_card

func _on_card_mouse_entered(w_card: W_Card) -> void:
	#if is_dragging: return
	highlight_card(w_card)

func _on_card_mouse_exited(w_card: W_Card) -> void:
	reset_highlight(w_card)
