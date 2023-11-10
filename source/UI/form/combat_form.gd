extends UIForm

@onready var lab_power: Label = %lab_power
@onready var btn_end_turn: Button = %btn_end_turn
@onready var card_container: Control = %CardContainer

var combat_scene : CombatScene
var player : Player 

signal end_turn_pressed

func _ready() -> void:
	btn_end_turn.pressed.connect(_on_btn_end_turn_pressed)
	player = GameInstance.player
	player.energy_changed.connect(
		func() -> void:
			display_energy()
	)
	display_energy()

func _on_btn_end_turn_pressed() -> void:
	end_turn_pressed.emit()

func display_energy() -> void:
	lab_power.text = str(player.current_energy) + "/" + str(player.max_energy)
