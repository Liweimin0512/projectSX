extends Node

var current_scene : SceneBase

func change_scene(view_name: StringName, msg:Dictionary = {}) -> Node:
	var scene_view := create_scene(view_name)
	if current_scene:
		current_scene._exit()
	current_scene = scene_view
	get_tree().root.add_child(current_scene)
	if current_scene:
		current_scene._enter(msg)
	return scene_view

func create_scene(scene_name: StringName) -> Node:
	var t_scene_path : String = AssetUtility.get_scene_path(scene_name)
	assert(ResourceLoader.exists(t_scene_path), "无法加载场景文件")
	return load(t_scene_path).instantiate()
