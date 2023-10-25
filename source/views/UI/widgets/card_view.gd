extends Control
class_name CardView

enum CARD_STATE {
	NORMAL, 
	DRAGGING, 
	PREVIEW,
	PRERELEASE, 
	}

const CARD_TYPE_NAME = [
	"UNKNOW",
	"攻击",
	"技能",
]

@onready var lab_name: Label = %lab_name
@onready var tr_icon: TextureRect = %tr_icon
@onready var lab_description: RichTextLabel = %lab_description
@onready var lab_type: Label = %lab_type
@onready var lab_cost: Label = %lab_cost

var can_release : bool = false

@export var card_state : CARD_STATE = CARD_STATE.NORMAL
@export var tween_speed : float = 0.1
@export var is_back : bool

@onready var card : TextureRect = $t_card
@onready var timer_preview = $timer_preview
@onready var timer_release = $timer_release

var controller : Card
var model: CardModel:
	get:
		return controller.card_data
	set(value):
		pass

signal card_mouse_entered
signal card_mouse_exited

func _ready():
	self.mouse_entered.connect(_on_card_mouse_entered)
	self.mouse_exited.connect(_on_card_mouse_exited)
	card.pivot_offset = Vector2(card.size.x/2, card.size.y)
	lab_name.text = model.card_name
	lab_description.text = model.card_description
	lab_type.text = CARD_TYPE_NAME[model.card_type]
	lab_cost.text = str(model.cost)

func predragging():
	if card_state == CARD_STATE.PRERELEASE:
		print("predragging")
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(card, "scale", Vector2(1,1), tween_speed)
		tween.play()
		card_state = CARD_STATE.DRAGGING

func prerelease():
	if card_state != CARD_STATE.PRERELEASE:
		# print("prerelease")
		var tween : Tween = get_tree().create_tween()
		tween.interpolate_property(card, "scale", Vector2(1.5,1.5), tween_speed)
		tween.play()
		card_state = CARD_STATE.PRERELEASE

func release():
	pass


## 鼠标进入
func _on_card_mouse_entered():
	card_mouse_entered.emit()

## 鼠标退出
func _on_card_mouse_exited():
	card_mouse_exited.emit()
