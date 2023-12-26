extends Control
class_name W_Card

@onready var lab_name: Label = %lab_name
@onready var tr_icon: TextureRect = %tr_icon
@onready var lab_description: RichTextLabel = %lab_description
@onready var lab_type: Label = %lab_type
@onready var lab_cost: Label = %lab_cost
@onready var t_card : TextureRect = $t_card
@onready var tip_container: VBoxContainer = %TipContainer

@export var tween_speed : float = 0.1
@export var is_back : bool

var card : Card
var _model: CardModel:
	get:
		if not card:
			return null
		return card._model

signal drag_started

func _ready():
	for tip in tip_container.get_children():
		tip.queue_free()
	init_data()

func init_data() -> void:
	if _model == null: 
		push_warning("卡牌 _model 为空！")
		return
	lab_name.text = _model.card_name
	lab_description.text = _model.card_description
	lab_type.text = Card.CARD_TYPE_NAME[_model.card_type]
	lab_cost.text = str(_model.cost)
	tr_icon.texture = _model.icon
	if not _model.buff_des.is_empty():
		for buffID : StringName in _model.buff_des:
			var buff_data: Dictionary = DatatableManager.get_datatable_row("buff", buffID)
			var w_tip = load("res://source/UI/widgets/w_tooltip.tscn").instantiate()
			if buff_data.is_empty(): continue
			w_tip.set_tooltip(buff_data.name, buff_data.description)
			tip_container.add_child(w_tip)
			w_tip.show()
	tip_container.hide()

func highlight() -> void:
	pass

func unhighlight() -> void:
	pass

## 预览
func preview() -> void:
	if not _model.buff_des.is_empty():
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
	return self.name + " : " + _model.card_name
