extends MarginContainer

@onready var lab_name: Label = %lab_name
@onready var lab_hero: Label = %lab_hero
@onready var w_status_health: MarginContainer = %w_status_health
@onready var w_status_coin: MarginContainer = %w_status_coin

var player: Player

func _ready() -> void:
	player = GameInstance.player
	display_health_status()
	player.damaged.connect(
		func() -> void:
			display_health_status()
	)

func display_health_status() -> void:
	w_status_health.text = str(player.current_health) + "/" + str(player.max_health)
