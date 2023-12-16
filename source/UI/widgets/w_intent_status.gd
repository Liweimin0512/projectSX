extends Control

@onready var sprite: TextureRect = %sprite
@onready var label: Label = %Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var intent_system: C_IntentSystem

func _ready() -> void:
	intent_system.intent_choosed.connect(set_status)
	intent_system.intent_executed.connect(execute_intent)
	self.hide()

func set_status(intent: Intent) -> void:
	self.show()
	if not intent: 
		push_error("意图为空！")
		return
	sprite.texture = intent.icon
	label.text = str(intent.value) if intent.value > 0 else ""

func execute_intent() -> void:
	self.hide()
	animation_player.play("execute")
	await animation_player.animation_finished
	animation_player.play("idle")
