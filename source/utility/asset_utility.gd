extends Node
class_name AssetUtility

const scene_path: String = "res://source/scenes/"
const form_path: String = "res://source/UI/form/"
const entity_path : String = "res://source/entities/"
const enemy_path: String = "res://source/entities/enemy/"
const t_arrow_head_path : String = "res://asserts/textures/widgets/right.png"
const t_arrow_body_path : String = "res://asserts/textures/widgets/fightJ.png"

static func get_entity_path(entity_name: String) -> String:
	return entity_path + entity_name + ".tscn"

static func get_enemy_path(enemy_name: String) -> String:
	return enemy_path + enemy_name + ".tscn"

static func get_scene_path(scene_name: String) -> String:
	return scene_path + scene_name + '.tscn'
