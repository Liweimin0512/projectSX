extends Control
class_name CardView

enum CARD_STATE {
	NORMAL, 
	DRAGGING, 
	PREVIEW,
	PRERELEASE, 
	}

@onready var lab_name: Label = %lab_name
@onready var tr_icon: TextureRect = %tr_icon
@onready var lab_description: RichTextLabel = %lab_description

var can_release : bool = false

@export var card_state : CARD_STATE = CARD_STATE.NORMAL
@export var tween_speed : float = 0.1
@export var is_back : bool

@onready var card : TextureRect = $t_card
@onready var timer_preview = $timer_preview
@onready var timer_release = $timer_release

signal card_mouse_entered
signal card_mouse_exited

func _ready():
	self.mouse_entered.connect(_on_card_mouse_entered)
	self.mouse_exited.connect(_on_card_mouse_exited)
	card.pivot_offset = Vector2(card.size.x/2, card.size.y)
#	if is_back == true:
#		card.texture = card_resource.card_back_resource
#	else:
#		var card_res_file = card_resource.card_resource_path + card_resource.card_name + ".png"
#		card.texture = load(card_res_file)

## 卡牌的初始化操作
func init(card: Card) -> void:
	lab_name.text = card.card_name
	lab_description.text = card.card_description


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
