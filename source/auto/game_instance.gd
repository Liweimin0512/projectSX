extends Node

var game_main = null :
	set(value) : game_main = value
	get : return game_main
var player: Character :
	get:
		return game_main.player

## 创建实体
func create_entity(entity_path: String) -> Node:
	var view = load(entity_path).instantiate()
	return view

func create_timer(time_sec: float) -> SceneTreeTimer:
	return get_tree().create_timer(time_sec)
