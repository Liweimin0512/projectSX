extends CharacterView
class_name EnemyView

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	super()
	controller.action_before.connect(_attack)

func _attack() ->void:
	animation_player.play("attack")
	await animation_player.animation_finished
	controller.action_end.emit()
	animation_player.play("idle")
