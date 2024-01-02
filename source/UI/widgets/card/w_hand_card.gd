extends Container
class_name W_HandCard

## 动效的时间
@export var tween_speed : float = 0.05
## 手中最大牌数限制
@export var max_num_cards: int = 12
## 卡牌之间的水平偏移比例
@export var card_offset_ratio: float = 0.7  
## 卡牌尺寸
@export var card_size : Vector2 = Vector2(108,160)
## 垂直方向位移系数
@export var vertical_drop_factor : float = 10
## 抽牌堆引用
@export var draw_deck: W_Deck
## 弃牌堆引用
@export var discard_deck: W_Deck

## 预览卡牌
var _preview_card : W_Card : set = _preview_card_setter

func _ready() -> void:
	self.child_entered_tree.connect(_on_child_entered_tree)
	self.child_exiting_tree.connect(_on_child_exiting_tree)
	self.child_order_changed.connect(_on_child_order_changed)

## 重置布局
func reset_layout() -> void:
	_update_card_layout()

## 获取卡牌widget（根据逻辑层card)
func get_card(card: Card) -> W_Card:
	for c in get_children():
		if c.card == card:
			return c
	return null

## 更新手牌布局
func _update_card_layout() -> void:
	var card_count: int = get_child_count()
	for i in range(card_count):
		var tween : Tween = create_tween()
		if not tween: return
		tween.set_parallel()
		var card : W_Card = get_child(i)
		if not card : return
		var transform: Transform2D = _calculate_card_transform(i, card_count)
		var angle: float = rad_to_deg(transform.get_rotation())
		var position: Vector2 = transform.get_origin()
		if card == _preview_card:
			angle = 0
		var scale: Vector2 = Vector2.ONE if card != _preview_card else Vector2.ONE * 1.5
		tween.tween_property(card, "rotation_degrees", angle, tween_speed)
		tween.tween_property(card, "position", position, tween_speed)
		tween.tween_property(card, "scale", scale, tween_speed)
		card.z_index = 0 if card != _preview_card else 1
		await tween.finished

## 计算卡牌位置和角度
func _calculate_card_transform(card_index: int, card_count: int) -> Transform2D:
	var middle_index: float = card_count / 2.0
	var offset_from_middle: float = card_index - middle_index
	# 使用非线性插值来确保中间的卡牌几乎不旋转
	var normalized_offset = offset_from_middle / middle_index
	## TODO : 手牌的角度设置
	var angle : float = 0 
	var vertical_offset = abs(normalized_offset) * vertical_drop_factor
	# 可以根据需要调整垂直位置
	var position_y = card_size.y * 0.3 + vertical_offset if card_index != _get_card_index(_preview_card) else 0
	var position = Vector2(
		offset_from_middle * card_offset_ratio * card_size.x - card_size.x * 0.5, 
		position_y - card_size.y
		)
	if _preview_card:
		if card_index != _get_card_index(_preview_card):
			position.x += 0.3 / (card_index - _get_card_index(_preview_card)) * card_size.x
	var rotation = deg_to_rad(angle)
	return Transform2D(rotation, position)

## 获取卡牌在手牌中的索引
func _get_card_index(w_card: W_Card) -> int:
	var i : int = 0
	for card in self.get_children():
		if card == w_card:
			return i
		i += 1
	return -1

## 添加子节点的处理函数
func _on_child_entered_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.connect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.connect(_on_card_mouse_exited.bind(node))
	node.global_position = draw_deck.global_position
	node.scale = Vector2.ZERO
	node.size = card_size

## 移除子节点的处理函数
func _on_child_exiting_tree(node: Node) -> void:
	if not node is W_Card: return
	node.mouse_entered.disconnect(_on_card_mouse_entered.bind(node))
	node.mouse_exited.disconnect(_on_card_mouse_exited.bind(node))
	node.queue_free()

## 更改子节点的处理函数
func _on_child_order_changed() -> void:
	await _update_card_layout()

## 鼠标进入某个卡牌
func _on_card_mouse_entered(w_card: W_Card) -> void:
	_preview_card = w_card

## 鼠标退出某个卡牌
func _on_card_mouse_exited(w_card: W_Card) -> void:
	if _preview_card == w_card:
		_preview_card = null

func _preview_card_setter(value: W_Card) -> void:
	if _preview_card == value: 
		print("_preview_card == value")
		return
	if _preview_card:
		_preview_card.cancel_preview()
	_preview_card = value
	if _preview_card:
		_preview_card.preview()
	_update_card_layout()
