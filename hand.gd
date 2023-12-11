extends Control

var radius: float = 200.0  # 扇形半径
var max_angle: float = 60.0  # 最大扇形角度

func _ready() -> void:
	_update_hand_layout()

func _calculate_card_rotation(card_index: int, card_count: int) -> float:
	var spread_angle_degrees = min(max_angle, card_count * 10.0)
	var angle_step = spread_angle_degrees / max(card_count - 1, 1)
	var angle_degrees = -spread_angle_degrees / 2 + angle_step * card_index
	return angle_degrees

func _calculate_card_position(angle_degrees: float) -> Vector2:
	var angle_radians = deg_to_rad(angle_degrees)
	var card = self.get_child(0)
	# 扇形的中心点是 Hand 节点的位置
	var offset = Vector2(sin(angle_radians), -cos(angle_radians)) * radius
	return offset + Vector2(
		card.size.x/2 * -1,
		card.size.y * -1 + radius
	)

func _update_hand_layout():
	var card_count = get_child_count()
	for i in range(card_count):
		var card = get_child(i)
		card.rotation_degrees = _calculate_card_rotation(i, card_count)
		card.position = _calculate_card_position(card.rotation_degrees)
		print(card.position)
