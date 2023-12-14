extends MarginContainer
class_name W_Buff

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

var buff: Buff

func _ready() -> void:
	if not buff : return
	texture_rect.texture = buff.icon
	label.text = str(buff.value)

func display() -> void:
	label.text = str(buff.value)
	
