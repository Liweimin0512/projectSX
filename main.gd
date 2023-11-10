extends CanvasLayer

@onready var procedure_manager: ProcedureManager = %ProcedureManager
@onready var ui_manager: CanvasLayer = %UIManager

var player: Character
var value = 0

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

func begin_game() -> void:
	player = GameInstance.create_entity(AssetUtility.get_entity_path("player"))
	player.cha_id = "1"
	self.add_child(player)
#	combat_scene = CombatScene.new("1")
	var combat_scene : CombatScene = SceneManager.change_scene("combat_scene", {"combat_id": "1"})
