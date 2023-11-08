extends UIForm

@onready var lab_power: Label = %lab_power
@onready var btn_end_turn: Button = %btn_end_turn
@onready var card_container: Control = %CardContainer

var _controller : CombatSceneLogic

signal end_turn_pressed

func _ready() -> void:
	btn_end_turn.pressed.connect(_on_btn_end_turn_pressed)

func _on_btn_end_turn_pressed() -> void:
	end_turn_pressed.emit()
