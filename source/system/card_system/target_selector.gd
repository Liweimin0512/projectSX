extends RefCounted
class_name TargetSelector

## 选中的角色
var _target_cha : Character = null:
	set(value):
		target_changed.emit(_target_cha, value)
		_target_cha = value

## 筛选条件
var filter_conditions = {}  # 筛选条件，如 {"team": "enemy"}

## 目标发生改变
signal target_changed(old: Character, new: Character)

func _init(_filter_conditions = {}):
	filter_conditions = _filter_conditions
	EventBus.subscribe("character_mouse_entered", 
		func(cha: Character) -> void:
			if _meets_conditions(cha):
				_target_cha = cha
	)
	EventBus.subscribe("character_mouse_exited", 
		func(cha: Character) -> void:
			_target_cha = null
	)

## 存在目标
func has_target() -> bool:
	return _target_cha != null

## 获取目标
func get_target() -> Character:
	return _target_cha

## 条件判断
func _meets_conditions(selected_character: Character) -> bool:
	if selected_character.is_death : return false
	for condition in filter_conditions:
		var value = filter_conditions[condition]
		if selected_character.get(condition) != value:
			return false
	return true
