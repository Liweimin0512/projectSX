extends MarginContainer

@onready var sprite: TextureRect = %sprite
@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_status(intent: Intent) -> void:
	sprite.texture = intent.icon
	label.text = str(intent.value) if intent.value > 0 else ""

func execute_intent() -> void:
	animation_player.play("execute")
	await animation_player.animation_finished
	animation_player.play("idle")
