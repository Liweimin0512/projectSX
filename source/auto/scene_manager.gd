extends Node

var current_scene : Entity
	
func change_scene(view_name: StringName, msg:Dictionary = {}) -> Node:
	if current_scene:
		var c_scene = current_scene.get_component("C_SceneBase")
		c_scene._exit()
	var scene_view := create_scene(view_name)
	if current_scene:
		var c_scene = current_scene.get_component("C_SceneBase")
		c_scene._enter(msg)
	self.add_child(scene_view)
	return scene_view

func create_scene(scene_name: StringName) -> Node:
	var t_scene_path : String = AssetUtility.get_scene_path(scene_name)
	assert(ResourceLoader.exists(t_scene_path), "无法加载场景文件")
	return load(t_scene_path).instantiate()
