extends MarginContainer

@onready var lab_name: Label = %lab_name
@onready var lab_hero: Label = %lab_hero
@onready var lab_health: Label = %lab_health
@onready var lab_coin: Label = %lab_coin

var player: Player

func _ready() -> void:
	player = GameInstance.player
	display_health_status()
	player.current_health_changed.connect(
		func(_value: float) -> void:
			display_health_status()
	)

func display_health_status() -> void:
	lab_health.text = "血量" + str(player.current_health) + "/" + str(player.max_health)
