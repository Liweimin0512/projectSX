@tool
extends Node
class_name Entity

var _components : Dictionary = {}

func _enter_tree() -> void:
	for child in get_children():
		if is_component(child):
			_components[child.component_name] = child

## 添加组件
func add_component(component: Object) -> bool:
	if not is_component(component):
		return false
	if _components.has(component.component_name):
		return false
	if "_owner" in component:
		component._owner = self
	_components[component.component_name] = component
	return true

## 删除组件
func remove_component(component: Object) -> bool:
	if not is_component(component):
		return false
	return _components.erase(component.component_name)

## 获取组件
func get_component(component_name: StringName) -> Object:
	if _components.has(component_name):
		return _components[component_name]
	return null

## 存在组建
func has_component(component_name: StringName) -> bool:
	return _components.has(component_name)

## 判断是否为组件
static func is_component(component: Node) -> bool:
	return "component_name" in component
