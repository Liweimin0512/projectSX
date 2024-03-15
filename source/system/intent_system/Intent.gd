extends RefCounted
class_name Intent

# 意图的基础类

var _model: IntentModel
var _caster: Character: set = _readonly, get = _caster_getter
func _caster_getter(): return _model._caster
var intent_name: String: set = _readonly, get = _intent_name_getter
func _intent_name_getter() : return _model.intent_name
var description: String: set = _readonly, get = _decription_getter
func _decription_getter(): return _model.description
var icon: Texture: set = _readonly, get = _icon_getter
func _icon_getter(): return _model.icon
var value: float: set = _readonly, get = _value_getter
func _value_getter(): return _model.value
var effects: Array : set = _readonly, get = _effects_getter 
func _effects_getter(): return _model.effects
var weight : float : set = _readonly, get = _weigh_getter
func _weigh_getter() : return _model.weight

## 当前状态是否可用
var is_available: bool = true :
	get:
		return _model.cooldown == 0

func _init(caster: Character, intentID: StringName) -> void:
	_model = IntentModel.new(caster, intentID)

## 刷新冷却
func process_cooldown() -> void:
	if _model.cooldown > 0:
		_model.cooldown -= 1

## 实现意图的具体逻辑
func execute() -> void:
	if not _model.play_animation.is_empty():
		await _caster.play_animation_with_reset(_model.play_animation)
	else:
		await _caster.get_tree().create_timer(1).timeout
	_model.cooldown = _model.max_cooldown
	for effectID : StringName in effects:
		Effect.try_execute(effectID, _caster, [GameInstance.player])
	#print("执行意图： ", self.intent_name)
	_caster.play_animation_with_reset("idle")

func _to_string() -> String:
	return intent_name

func _readonly(value) -> void:
	assert(false, "尝试给只读属性赋值！")
