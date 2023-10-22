extends CanvasLayer
class_name UIManager

"""
管理和协调所有UI元素和UI界面。
提供方法来打开、关闭、或切换UI窗口。
可能还需要管理UI资源和配置，以及处理UI相关的事件和输入。
"""
@export var ui_path : String = "res://src/widgets/"

var current_interface : UIBase:
	get:
		return self.get_child(-1)

func create_interface(name: StringName, path: String = "") -> Control:
	var widget_path : String = ui_path + name + ".tscn" if path.is_empty() else path
	assert(ResourceLoader.exists(widget_path), "UI资源路径不识别！")
	var control : Control = load(widget_path).instantiate()
	if "interface_name" in control:
		control.interface_name = name
	return control

func get_interface(ui_name: StringName) -> Control:
	for interface in get_children():
		if interface.interface_name == ui_name:
			return interface
	return null

func open_interface(ui_name: StringName, path: String = "", msg: Dictionary = {}) -> UIBase:
	if current_interface:
		current_interface.hide()
	var interface = get_interface(ui_name)
	if interface:
		self.move_child(interface, -1)
	else:
		interface = create_interface(ui_name, path)
		self.add_child(interface)
	if interface.has_method("_opened"):
		interface._opened(msg)
	interface.show()
	return interface

func close_current_interface() -> void:
	var interface = current_interface
	self.remove_child(interface)
	interface._closed()
	interface.queue_free()
#	current_interface._opened()
	current_interface.show()

func emit(destination : StringName, payload) -> void:
	'''
	发射事件信号
	'''
	if not payload is Array:
		payload = [payload]
	payload.insert(0, get_destination_signal(destination))
	callv("emit_signal", payload)

func subscribe(destination: String, callback: Callable) -> void:
	'''
	订阅事件信号
	'''
	var dest_signal: StringName = get_destination_signal(destination)
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		connect(dest_signal, callback)

func unsubscribe(destination: String, callback: Callable) -> void:
	'''
	取消订阅事件信号
	'''
	var dest_signal: StringName = get_destination_signal(destination)
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		disconnect(dest_signal, callback)

func get_destination_signal(destination: String) -> StringName:
	'''
	获取目标信号名称
	'''
	var dest_signal: StringName = "EventBus|%s" % destination
	if not has_user_signal(dest_signal):
		add_user_signal(dest_signal)
	return dest_signal
