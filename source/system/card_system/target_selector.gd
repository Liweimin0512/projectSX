extends RefCounted
class_name TargetSelector

var _target_cha : Character = null:
	set(value):
		target_changed.emit(_target_cha, value)
		_target_cha = value

## 目标发生改变
signal target_changed(old: Character, new: Character)
## 筛选条件
var filter_conditions = {}  # 筛选条件，如 {"team": "enemy"}

func _init(_filter_conditions = {}):
	filter_conditions = _filter_conditions
	EventBus.subscribe("character_mouse_entered", _on_character_mouse_entered)
	EventBus.subscribe("character_mouse_exited", _on_character_mouse_exited)

func select_target(selected_character: Character) -> void:
	if _meets_conditions(selected_character):
		_target_cha = selected_character

func has_target() -> bool:
	return _target_cha != null

func get_target() -> Character:
	return _target_cha

func _meets_conditions(selected_character: Character) -> bool:
	if selected_character.is_death : return false
	for condition in filter_conditions:
		var value = filter_conditions[condition]
		if selected_character.get(condition) != value:
			return false
	return true

func _on_character_mouse_entered(cha: Character) -> void:
	select_target(cha)

func _on_character_mouse_exited(cha: Character) -> void:
	_target_cha = null
