extends MarginContainer
class_name W_HealthBar

@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label
@onready var buff_container: HBoxContainer = %buff_container

## 红色血条样式
var box_line_red := StyleBoxLine.new()
## 带有护盾效果的血条样式
var box_line_shielded := StyleBoxLine.new()

func _ready() -> void:
	box_line_red.color = Color.RED
	box_line_red.thickness = 10
	box_line_shielded.color = Color.SKY_BLUE
	box_line_shielded.thickness = 10
	for buff in buff_container.get_children():
		buff.queue_free()

## 添加Buff控件
func add_buff_widget(buff: Buff) -> void:
	var w_buff: W_Buff = _create_buff_widget(buff)
	buff_container.add_child(w_buff)

## 更新显示：当前hp、最大hp、护盾值
func update_display(current_health: float, max_health: float, shielded: float) -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)
	if shielded > 0:
		health_label.text += " + " + str(shielded)
		health_bar.add_theme_stylebox_override("fill", box_line_shielded)
	else:
		health_bar.add_theme_stylebox_override("fill", box_line_red)

## 创建Buff控件
static func _create_buff_widget(buff: Buff) -> W_Buff:
	var w_buff: W_Buff = load("res://source/UI/widgets/w_buff.tscn").instantiate()
	w_buff.buff = buff
	return w_buff

