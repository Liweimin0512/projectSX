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

var _model: IntentModel
var _caster: Character:
	get:
		return _model._caster
	set(value):
		_model._caster = value

var intent_name: String:
	get:
		return _model.intent_name
var description: String:
	get:
		return _model.description
var icon: Texture:
	get:
		return _model.icon
var value: float:
	get:
		return _model.value
var cooldown: float:
	get:
		return _model.cooldown
	set(value):
		_model.cooldown = value
var play_animation : StringName:
	get:
		return _model.play_animation
var max_cooldown: int:
	get:
		return _model.max_cooldown
var weight: int:
	get:
		return _model.weight
var effects: Array : 
	get: return _model.effects

## 当前状态是否可用
var is_available: bool = true :
	get:
		return cooldown == 0


func _init(caster: Character, intentID: StringName) -> void:
	_model = IntentModel.new(caster, intentID)

## 刷新冷却
func process_cooldown() -> void:
	if cooldown > 0:
		cooldown -= 1

## 实现意图的具体逻辑
func execute() -> void:
	if not play_animation.is_empty():
		await _caster.play_animation_with_reset(play_animation)
	else:
		await _caster.get_tree().create_timer(1).timeout
	cooldown = max_cooldown
	for effectID : StringName in effects:
		Effect.try_execute(effectID, _caster, [GameInstance.player])
	print("执行意图： ", self.intent_name)
	_caster.play_animation_with_reset("idle")

## 返回意图的描述
func get_description() -> String:
	return ""

func _to_string() -> String:
	return intent_name
