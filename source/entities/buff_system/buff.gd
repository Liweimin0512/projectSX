extends RefCounted
class_name Buff

var _model: BuffModel

var buff_id: StringName:
	get:
		return _model.id

var buff_name: StringName:
	get:
		return _model.buff_name

var icon: Texture:
	get:
		return _model.icon
var value: int:
	get:
		return _model.value

func _init(buff_id: StringName, value: int) -> void:
	_model = BuffModel.new(buff_id, value)
