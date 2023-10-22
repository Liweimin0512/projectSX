extends Node
class_name BaseStateMachine

## 当前状态
var current_state : BaseState = null
## 用于存储所有可用的状态
var states : Dictionary = {}

## 状态机代理
@export var agent : Node
## 判断状态机是否运行
var is_run : bool = false
## 状态机参数集合
var values : Dictionary = {}
## 在节点的每一帧调用状态机当前状态的逐帧调用的方法
func _process(delta: float) -> void:
	if not current_state: return
	current_state.update(delta)
## 在节点的每一物理帧调用状态机当前状态的逐物理帧调用的方法
func _physics_process(delta: float) -> void:
	if not current_state: return
	current_state.physics_update(delta)
## 启动状态机
func launch(state_index : int = 0) -> void:
	assert(agent, '代理不能为空！')
	is_run = true
	self.current_state = states[state_index]
	self.current_state.enter()
## 添加状态
func add_state(state_type : int, state : BaseState) -> void:
	states[state_type] = state
## 删除状态
func remove_state(state_type: int) -> void:
	states.erase(state_type)
## 切换状态
func transition_to(state_index: int, msg:Dictionary = {}) -> void:
	self.current_state.exit()
	self.current_state = states[state_index]
	self.current_state.enter(msg)
## 根据名称设置属性的值
func set_variable(name : StringName, value : Variant) -> void:
	values[name] = value
## 根据名称获取属性的值
func get_variable(name: StringName) -> Variant:
	if values.has(name):
		return values[name]
	return null
## 是否存在属性
func has_variable(name: StringName) -> bool:
	return values.has(name)
