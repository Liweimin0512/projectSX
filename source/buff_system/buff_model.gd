extends Resource
class_name BuffModel

enum BUFF_TYPE { 
	NONE,
	STACKABLE, 	# 表示这个Buff是可以堆叠的
	CONSTANT, 	# 表示这个Buff的效果是固定的，不会因重复应用而改变。
	DECREASING 	# 表示这个Buff的效果会随时间逐渐减少。
}

enum DURATION_TYPE{
	NONE,
	ALWAYS,	# 永久的；
	TURN,	# 持续若干回合的；
}

var id : StringName = ""
var buff_name: StringName = ""
var description : String = ""
var icon: Texture = null
var buff_type := BUFF_TYPE.NONE
var duration_type: DURATION_TYPE = DURATION_TYPE.NONE
var callback_type: Buff.CALLBACK_TYPE = Buff.CALLBACK_TYPE.NONE
var effects : PackedStringArray = []

var value: int = 0	 # Buff的强度或层数

var caster: Character # 当前BUFF的拥有者
var target: Character # 当前BUFF的目标

var is_stacked: bool:
	get:
		return buff_type == BUFF_TYPE.STACKABLE

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

func is_turn() -> bool:
	return buff_type == BUFF_TYPE.STACKABLE and duration_type == DURATION_TYPE.TURN

