extends Resource
class_name BuffModel

enum DURATION_TYPE{
	NONE,
	ALWAYS,
	TURN,
}

var id : StringName = ""
var buff_name: StringName = ""
var description : String = ""
var effects : PackedStringArray = []
var duration: DURATION_TYPE = DURATION_TYPE.NONE
var icon: Texture = null

var value: int = 0

func _init(id : StringName, value: int) -> void:
	self.id = id
	var data : Dictionary = DatatableManager.get_datatable_row("buff", id)
	self.buff_name = data.name
	description = data.description
	effects = data.effects
	duration = data.duration
	icon = data.icon
	self.value = value
