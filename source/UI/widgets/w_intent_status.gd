extends MarginContainer

@onready var sprite: TextureRect = %sprite
@onready var label: Label = %Label

func set_status(intent: Intent) -> void:
	sprite.texture = intent.icon
	label.text = str(intent.value) if intent.value > 0 else ""
