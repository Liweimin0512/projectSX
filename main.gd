extends CanvasLayer

var t_player := preload("res://source/entities/player_character.tscn")
var t_combat_scene := preload("res://source/scenes/combat_scene.tscn")
var t_map_scene := preload("res://source/scenes/map_scene.tscn")
@onready var procedure_manager: ProcedureManager = %ProcedureManager

var player: PlayerCharacter
var combat_scene : CombatScene

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

func begin_game() -> void:
	player = t_player.instantiate()
	player.init("1")
	self.add_child(player)
	combat_scene = t_combat_scene.instantiate()
	self.add_child(combat_scene)
	combat_scene.init_combat("1")
#	self.add_child(player)
