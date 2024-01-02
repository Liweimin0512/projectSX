extends Resource
class_name IntentModel

@export var intent_name : String = ""
@export var description: String
@export var icon: Texture # 意图的图标路径

## 意图相关的数值
@export var value: int

var effects : Array

var cooldown: int = 0
@export var max_cooldown: int = 0
## 意图权重
@export var weight: float = 1

var play_animation: StringName


var _caster: Character

func _init(caster: Character, intentID: StringName) -> void:
	_caster = caster
	var data: Dictionary = DatatableManager.get_datatable_row("intent", intentID)
	intent_name = data.name
	description = data.des
	weight = data.weight
	max_cooldown = data.cooldown
	icon = data.icon
	value = data.value
	effects = data.effects
	play_animation = data.play_animation
