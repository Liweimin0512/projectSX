extends CanvasLayer

var t_player := preload("res://source/entities/character_player.tscn")
@onready var procedure_manager: ProcedureManager = %ProcedureManager

var player: PlayerCharacter

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

func begin_game() -> void:
	player = t_player.instantiate()
	player.init("1")
#	self.add_child(player)
