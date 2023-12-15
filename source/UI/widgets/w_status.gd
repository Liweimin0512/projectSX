extends MarginContainer
class_name W_Status

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %label

var text : String = "":
	get:
		return label.text
	set(value):
		label.text = value

func _ready() -> void:
	texture_rect.pivot_offset = texture_rect.size / 2
	self.mouse_entered.connect(
		func() -> void:
			texture_rect.scale *= 1.2
	)
	self.mouse_exited.connect(
		func() -> void:
			texture_rect.scale = Vector2.ONE
	)
