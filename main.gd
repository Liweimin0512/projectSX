extends CanvasLayer

@onready var procedure_manager: ProcedureManager = %ProcedureManager
@onready var ui_manager: CanvasLayer = %UIManager


var player: PlayerLogic
var current_scene : SceneBaseLogic
var value = 0

func _ready() -> void:
	GameInstance.game_main = self
	procedure_manager.launch()

func begin_game() -> void:
	player = PlayerLogic.new("1")
#	combat_scene = CombatScene.new("1")
	var combat_form = ui_manager.open_interface("combat_form", AssetUtility.form_path + "combat_form.tscn")
	var combat_scene_view = change_scene(CombatSceneLogic, "combat_scene", {"combat_id": "1"})
	combat_form._controller = current_scene
	
func change_scene(scene_controller: Script, view_name: StringName, msg:Dictionary = {}) -> Node:
	if current_scene:
		current_scene._exit()
	current_scene = scene_controller.new()
	var scene_view := create_scene_view(view_name)
	scene_view.controller = current_scene
	if current_scene:
		current_scene._enter(msg)
	self.add_child(scene_view)
	return scene_view

func create_scene_view(view_name: StringName) -> Node:
	var t_scene_path : String = AssetUtility.scene_path + view_name + ".tscn"
	assert(ResourceLoader.exists(t_scene_path), "无法加载场景文件")
	return load(t_scene_path).instantiate() 
	
