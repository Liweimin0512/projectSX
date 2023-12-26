extends RefCounted
class_name Effect

enum EFFECT_TYPE {
	NONE,		# 未知
	DAMAGE,		# 造成伤害
	SHIELDED,	# 护盾
	ADD_BUFF,	# 给予BUFF
	VULNERABLE,		# 易伤
}

## 效果的所有者
var caster: Character 
## 效果的目标对象，可以是多个
var _targets : Array[Character] = []
## 效果名
var effect_name := ""
## 效果描述
var effect_description := ""
## 目标类型
var target_type := 0

func _init(data: Dictionary, caster: Character, targets: Array[Character]) -> void:
	_targets = get_effect_targets(caster, targets)
	effect_name = data.effect_name
	effect_description = data.description
	target_type = data.target_type
	self.caster = caster

## 执行效果
func execute() -> void:
	pass

## 获取效果目标
func get_effect_targets(caster: Character, targets: Array[Character]) -> Array:
	# TODO 根据效果的目标类型判断如何选择目标
	return targets

## 创建效果
static func create_effect(effectID: String, caster: Character, targets: Array[Character]) -> Effect:
	var data := DatatableManager.get_datatable_row("ability_effect", effectID)
	var effect : Effect = null
	match data.effect_type:
		EFFECT_TYPE.DAMAGE:
			effect = EffectDamage.new(data, caster, targets)
		EFFECT_TYPE.SHIELDED:
			effect = EffectShielded.new(data, caster, targets)
		EFFECT_TYPE.ADD_BUFF:
			effect = EffectApplyBuff.new(data, caster, targets)
		EFFECT_TYPE.VULNERABLE:
			effect = EffectVulnerable.new(data, caster, targets)
		_:
			push_error("未知的effect类型， 无法创建效果", data.effect_type)
	return effect

## 尝试创建并执行效果
static func try_execute(effectID: String, caster: Character, targets: Array[Character]) -> void:
	var effect = Effect.create_effect(effectID, caster, targets)
	if not effect:
		push_error("创建技能效果失败！")
	effect.execute()
