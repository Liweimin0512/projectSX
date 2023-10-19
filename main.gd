extends CanvasLayer

@onready var procedure_manager: ProcedureManager = %ProcedureManager

#@export var player_node := get_node("player_character")
@export var enemies : Array = []


#var card_manager : CardManager = $card_manager

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

