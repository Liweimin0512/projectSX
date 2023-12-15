extends RefCounted
class_name Intent

# 意图的基础类
enum INTENT_TYPE {
	NONE,
	ATTACK,
	MULTI_ATTACK,
	DEFEND,
	BUFF,
	DEBUFF,
	HEAL,
	STRATEGY,
	ESCAPE
}

@export var intent_name : String = ""
@export var description: String
@export var icon: Texture # 意图的图标路径

## 意图的类型，比如"attack", "defend", "buff", "debuff"等
@export var type: INTENT_TYPE 
## 意图相关的数值
@export var value: int

var effects : Array

var cooldown: int = 0
@export var max_cooldown: int = 0
## 意图权重
@export var weight: float = 1

var play_animation: StringName

## 当前状态是否可用
var is_available: bool = true :
	get:
		return cooldown == 0

var _caster: Character

func _init(caster: Character, intentID: StringName) -> void:
	_caster = caster
	var data: Dictionary = DatatableManager.get_datatable_row("intent", intentID)
	intent_name = data.name
	description = data.des
	weight = data.weight
	max_cooldown = data.cooldown
	icon = data.icon
	type = data.type
	value = data.value
	effects = data.effects
	play_animation = data.play_animation

## 刷新冷却
func process_cooldown() -> void:
	if cooldown > 0:
		cooldown -= 1

## 实现意图的具体逻辑
func execute() -> void:
	await _caster.play_animation_with_reset(play_animation)
	cooldown = max_cooldown
	for effectID : StringName in effects:
		Effect.try_execute(effectID, _caster, [GameInstance.player])
	print("执行意图： ", self.intent_name)
	_caster.play_animation_with_reset("idle")

## 返回意图的描述
func get_description() -> String:
	return ""
