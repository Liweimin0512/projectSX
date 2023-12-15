extends RefCounted
class_name Effect

enum EFFECT_TYPE {
	NONE,		# 未知
	DAMAGE,		# 造成伤害
	SHIELDED,	# 护盾
	ADD_BUFF,	# 给予BUFF
	VULNERABLE,		# 易伤
}

var caster: Character # 效果的所有者
var _targets : Array[Character] = []
var effect_name := ""
var effect_description := ""
var target_type := 0

func _init(data: Dictionary, caster: Character, targets: Array[Character]) -> void:
	_targets = targets
	effect_name = data.effect_name
	effect_description = data.description
	target_type = data.target_type
	self.caster = caster

## 执行效果
func execute() -> void:
	pass

## 获取效果目标
func get_effect_targets(caster: Character, selected_cha: Character = null) -> Array:
	return []

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

## 创建效果
static func try_execute(effectID: String, caster: Character, targets: Array[Character]) -> void:
	var effect = Effect.create_effect(effectID, caster, targets)
	if not effect:
		push_error("创建技能效果失败！")
	effect.execute()
