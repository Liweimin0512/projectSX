extends CanvasLayer

@onready var procedure_manager: ProcedureManager = %ProcedureManager
@onready var ui_manager: CanvasLayer = %UIManager

var player: Entity
var value = 0

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

func begin_game() -> void:
	player = GameInstance.create_entity(AssetUtility.get_entity_path("player"))
	self.add_child(player)
#	combat_scene = CombatScene.new("1")
	var combat_form = ui_manager.open_interface("combat_form", AssetUtility.form_path + "combat_form.tscn")
	var combat_scene : Entity = GameInstance.change_scene("combat_scene", {"combat_id": "1"})
	combat_form._controller = combat_scene

