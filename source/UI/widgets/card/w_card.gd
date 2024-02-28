extends Control
class_name W_Card

@onready var lab_name: Label = %lab_name
@onready var tr_icon: TextureRect = %tr_icon
@onready var lab_description: RichTextLabel = %lab_description
@onready var lab_type: Label = %lab_type
@onready var lab_cost: Label = %lab_cost
#@onready var t_card : TextureRect = $t_card
@onready var tip_container: VBoxContainer = %TipContainer

var card : Card # 是在ready方法之前赋值的

signal drag_started

func _ready():
	for tip in tip_container.get_children():
		tip.queue_free()
	lab_name.text = card.card_name
	lab_description.text = card.card_description
	lab_type.text = card.get_card_type_name()
	lab_cost.text = str(card.cost)
	tr_icon.texture = card.icon
	if not card.buff_des.is_empty():
		for buffID : StringName in card.buff_des:
			var buff_data: Dictionary = DatatableManager.get_datatable_row("buff", buffID)
			var w_tip = load("res://source/UI/widgets/w_tooltip.tscn").instantiate()
			if buff_data.is_empty(): continue
			tip_container.add_child(w_tip)
			w_tip.set_tooltip(buff_data.name, buff_data.description)
			w_tip.show()
	tip_container.hide()

## 高亮显示
func highlight() -> void:
	pass
## 取消高亮显示
func unhighlight() -> void:
	pass
## 预览
func preview() -> void:
	if not card.buff_des.is_empty():
		tip_container.show()
		#for tip in tip_container.get_children():
			#tip.show()
## 取消预览
func cancel_preview() -> void:
	tip_container.hide()
## 是否需要目标
func needs_target() -> bool:
	return card.needs_target()
## 当前能否拖动
func can_drag() -> bool:
	return card.can_release()

func _get_drag_data(at_position: Vector2) -> Variant:
	drag_started.emit(at_position)
	return null

func _to_string() -> String:
	return self.name + " : " + card.card_name
