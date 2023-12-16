extends Resource
class_name BuffModel

var id : StringName = ""
var buff_name: StringName = ""
var description : String = ""
var icon: Texture = null
var buff_type : = Buff.BUFF_TYPE.NONE
var duration_type: = Buff.DURATION_TYPE.NONE
var callback_type: = Buff.CALLBACK_TYPE.NONE
var is_stacked: bool = false
var effects : PackedStringArray = []
var value: int = 0	 # Buff的强度或层数

var caster: Character # 当前BUFF的拥有者
var target: Character # 当前BUFF的目标

func _init(id : StringName, value: int, caster: Character, target: Character) -> void:
	self.id = id
	var data : Dictionary = DatatableManager.get_datatable_row("buff", id)
	self.buff_name = data.name
	description = data.description
	effects = data.effects
	buff_type = data.buff_type
	duration_type = data.duration_type
	callback_type = data.callback_type
	icon = data.icon
	self.value = value
	self.caster = caster
	self.target = target
	is_stacked = data.is_stacked

