extends Node

var game_main = null :
	set(value) : game_main = value
	get : return game_main
var player: Entity :
	get:
		return game_main.player

## 创建实体
func create_entity(entity_path: String) -> Entity:
	var view : Entity = load(entity_path).instantiate()
	return view

func create_timer(time_sec: float) -> SceneTreeTimer:
	return get_tree().create_timer(time_sec)
