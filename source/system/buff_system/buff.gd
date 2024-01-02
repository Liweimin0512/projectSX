extends RefCounted
class_name Buff

## BUFF类型
enum BUFF_TYPE { 
	NONE,
	VALUE, 	# 数值型
	STATUS, 	# 状态型
}
## 持续类型
enum DURATION_TYPE{
	NONE,
	ALWAYS,	# 永久的；
	TURN,	# 持续若干回合的；
}
## 触发时机
enum CALLBACK_TYPE{
	NONE,
	TURN_START,			#1回合开始
	TURN_END,			#2回合结束
	BEFORE_ATTACK,		#3攻击前
	AFTER_ATTACK,		#4攻击后
	BEFORE_DAMAGE,		#5受到伤害前
	AFTER_DAMAGE,		#6受到伤害后
	BEFORE_ABILITY,		#7释放技能前
	AFTER_ABILITY,		#8释放技能后
	WHEN_HEALED,		#9被治疗时
	USE_CARD,		#10使用卡牌时
}

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
	set(value):
		_model.value = value
		value_changed.emit(_model.value)

var callback_type: CALLBACK_TYPE:
	get:
		return _model.callback_type
var buff_type: BUFF_TYPE:
	get:
		return _model.buff_type
var duration_type: DURATION_TYPE:
	get:
		return _model.duration_type
var effects: Array[Effect]
var execute_func: Callable

var is_stacked: bool:
	get:
		return _model.is_stacked
	
signal value_changed(value)

func _init(buff_id: StringName, value: int, caster: Character,  target: Character) -> void:
	_model = BuffModel.new(buff_id, value, caster, target)
	for effectID: StringName in _model.effects:
		var effect: Effect = Effect.create_effect(effectID, caster, [target])
		effects.append(effect)
	match _model.callback_type:
		CALLBACK_TYPE.BEFORE_DAMAGE:
			execute_func = _before_damage
		_:
			execute_func = _execute

## 执行BUFF
func _execute() -> void:
	for effect : Effect in effects:
		effect.execute()

func _before_damage(damage: Damage) -> void:
	for effect in effects:
		effect.set("damage", damage)
	_execute()

func can_stacked(buff: Buff) -> bool:
	return self.buff_id == buff.buff_id

func stack(buff: Buff) -> bool:
	if not can_stacked(buff) : return false
	self.value += buff.value
	return true
