extends Container
class_name W_HandCard

## 动效的时间
@export var tween_speed : float = 0.05
@export var offset : Vector2 = Vector2.ZERO
## 手中最大牌数限制
@export var max_num_cards: int = 12
#@export var rotation_proportion:float = 5

var highlighted_card : W_Card:
	set(value):
		if highlighted_card == value: 
			print("highlighted_card == value")
			return
		if highlighted_card:
			highlighted_card.unhighlight()
		highlighted_card = value
		if highlighted_card:
			highlighted_card.highlight()
		_update_card_layout()

# 手牌布局参数
# @export var radius: float = 400.0
@export var card_offset: float = 30.0  # 卡牌之间的水平偏移量
@export var max_angle: float = 20.0  # 卡牌之间最大角度差

@export var draw_deck: W_Deck
@export var discard_deck: W_Deck

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)
	self.child_order_changed.connect(_on_child_order_changed)

## 更新手牌布局
func _update_card_layout() -> void:
	print_debug("_update_card_layout")
	var card_count: int = get_child_count()
	var tween : Tween = create_tween()
	if not tween: return
	tween.set_parallel()
	for i in range(card_count):
		var card : W_Card = get_child(i)
		var angle: float = _calculate_card_angle(i, card_count)
		var position: Vector2 = _calculate_card_position(angle)
		if card == highlighted_card:
			angle = 0
		#if highlighted_card and abs(i+_get_card_index(highlighted_card)) <= 2 and card != highlighted_card:
			#position.x += 1/(i + _get_card_index(highlighted_card)) * 10
		var scale: Vector2 = Vector2.ONE if card != highlighted_card else Vector2.ONE * 1.2
		tween.tween_property(card, "rotation_degrees", angle, tween_speed)
		tween.tween_property(card, "position", position, tween_speed)
		tween.tween_property(card, "scale", scale, tween_speed)
		#card.rotation_degrees = angle
		#card.position = position
		#card.scale = Vector2.ONE
		# card.size = card.custom_minimum_size
		card.z_index = 0 if card != highlighted_card else 1
		# card.pivot_offset = Vector2(card.size.x/2, card.size.y)
		#card.scale = Vector2.ONE
	await tween.finished

## 计算卡牌的角度，根据卡牌的编号
func _calculate_card_angle(card_index: int, card_count: int) -> float:
	var spread_angle_degrees = min(max_angle, card_count * 10.0)
	var angle_step = spread_angle_degrees / max(card_count - 1, 1)
	var angle_degrees = -spread_angle_degrees / 2 + angle_step * card_index
	return angle_degrees

## 计算卡牌的位置，根据角度
func _calculate_card_position(angle_degrees: float) -> Vector2:
	var angle_radians = deg_to_rad(angle_degrees)
	var card = self.get_child(0)
	# 扇形的中心点是 Hand 节点的位置
	var offset = Vector2(sin(angle_radians), -cos(angle_radians)) * radius + Vector2(
		card.size.x/2 * -1,
		card.size.y * -1 + radius
	)
	return offset

func _get_card_index(w_card: W_Card) -> int:
	var i : int = 0
	for card in self.get_children():
		if card == w_card:
			return i
		i += 1
	return -1

func _on_child_entered_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.connect(_on_card_mouse_exited.bind(node))
	node.global_position = draw_deck.global_position
	node.scale = Vector2.ZERO

func _on_child_exiting_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.disconnect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.disconnect(_on_card_mouse_exited.bind(node))
	var tween: Tween = create_tween()
	tween.set_parallel()
	tween.tween_property(node, "global_position", discard_deck.global_position, 0.3)
	tween.tween_property(node, "scale", Vector2.ZERO, 0.3)
	await tween.finished
	node.queue_free()
	
func _on_child_order_changed() -> void:
	_update_card_layout()

func _on_card_mouse_entered(w_card: W_Card) -> void:
	highlighted_card = w_card

func _on_card_mouse_exited(w_card: W_Card) -> void:
	if highlighted_card == w_card:
		highlighted_card = null
	
