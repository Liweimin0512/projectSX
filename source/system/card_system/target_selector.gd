extends RefCounted
class_name TargetSelector

## 选中目标
signal target_selected(target)
## 取消选择
signal selection_canceled
## 筛选条件
var filter_conditions = {}  # 筛选条件，如 {"team": "enemy"}

func _init(_filter_conditions = {}):
	filter_conditions = _filter_conditions
	EventBus.subscribe("character_mouse_entered", _on_character_mouse_entered)
	EventBus.subscribe("character_mouse_exited", _on_character_mouse_exited)

func select_target(selected_character: Character) -> void:
	if _meets_conditions(selected_character):
		emit_signal("target_selected", selected_character)
	else:
		emit_signal("selection_canceled")

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
	selection_canceled.emit()
