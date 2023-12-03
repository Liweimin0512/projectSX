extends RefCounted
class_name Card

const CARD_TYPE_NAME = [
	"UNKNOW",
	"攻击",
	"技能",
]

var _model : CardModel

func _init(cardID: StringName) -> void:
	_model = CardModel.new(cardID)

## 是否需要目标
func needs_target() -> bool:
	return _model.needs_target()

## 能否释放
func can_release(caster: Character= null) -> bool:
	var _caster = caster if caster != null else GameInstance.player
	return _model.cost <= _caster.current_energy

## 释放卡牌
func release(caster: Character, targets: Array[Character]) -> void:
	var effects = create_effects(targets)
	await caster.play_animation(_model.play_animation)
	for effect in effects:
		effect.execute()
	# 消耗能量
	caster.use_energy(_model.cost)

## 获取效果目标
func get_effect_targets(caster: Character, targets: Array[Character]) -> Array:
	return _model.get_effect_targets(caster, targets)

## 创建效果
func create_effects(targets: Array[Character]) -> Array[Effect]:
	var caster : Character = GameInstance.player
	var _targets : Array[Character] = get_effect_targets(caster, targets)
	var effects: Array[Effect]
	for e in _model.effects:
		var effect = Effect.create_effect(e, _targets)
		if not effect:
			push_error("创建技能效果失败！")
		effects.append(effect)
	return effects
