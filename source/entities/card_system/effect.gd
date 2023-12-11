extends RefCounted
class_name Effect

enum EFFECT_TYPE {
	NONE,		# 未知
	DAMAGE,		# 造成伤害
	SHIELDED,	# 护盾
	ADD_BUFF,	# 给予BUFF
	STATUS,		# 特性
}

var _targets : Array[Character] = []
var effect_name := ""
var effect_description := ""
var target_type := 0

func _init(data: Dictionary, targets: Array) -> void:
	_targets = targets
	effect_name = data.effect_name
	effect_description = data.description
	target_type = data.target_type

func execute() -> void:
	pass

static func create_effect(effectID: String, targets: Array) -> Effect:
	var data := DatatableManager.get_datatable_row("ability_effect", effectID)
	var effect : Effect = null
	match data.effect_type:
		EFFECT_TYPE.DAMAGE:
			effect = EffectDamage.new(data, targets)
		EFFECT_TYPE.SHIELDED:
			effect = EffectShielded.new(data, targets)
		EFFECT_TYPE.ADD_BUFF:
			effect = EffectApplyBuff.new(data, targets)
		EFFECT_TYPE.STATUS:
			effect = EffectStatus.new(data, targets)
		_:
			push_error("未知的effect类型， 无法创建效果", data.effect_type)
	return effect
