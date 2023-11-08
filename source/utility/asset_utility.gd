extends Node
class_name AssetUtility

const card_view: String = "res://source/UI/widgets/w_card.tscn"

const scene_path: String = "res://source/entities/scenes/"
const form_path: String = "res://source/UI/form/"
const entity_path : String = "res://source/entities/"

static func get_entity_path(entity_name: String) -> String:
	return entity_path + entity_name + ".tscn"

static func get_scene_path(scene_name: String) -> String:
	return scene_path + scene_name + '.tscn'
