extends Control
class_name UIBase

"""
是所有具体UI界面（如UIForm, UIPopup）的基类。
包含对当前UIManager的持有，提供UI的name方便查找
包含开启和关闭UI界面时的回调函数
"""

var interface_name : StringName = ""
var ui_manager: UIManager :
	get:
		return get_parent()

func _opened(data: Dictionary = {}) -> void:
#	print("开启了界面：", interface_name)
	pass

func _closed() -> void:
#	print("关闭了界面：", interface_name)
	pass
