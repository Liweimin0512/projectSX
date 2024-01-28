extends RefCounted
class_name Card

## 卡牌数据model的引用
var _model : CardModel
## 卡牌名称
var card_name : String :
	get:
		return _model.card_name
var caster: Character = null

## 构造函数：通过id创建数据model
func _init(cardID: StringName) -> void:
	_model = CardModel.new(cardID)

## 是否需要目标
func needs_target() -> bool:
	return _model.needs_target()

## 能否释放
func can_release() -> bool:
	if _model.cost <= caster.current_energy:
		return true
	else:
		print("能量不足，无法释放卡牌！", self)
		return false

## 释放卡牌
func release(caster: Character, selected_cha: Character) -> void:
	assert(selected_cha != null, "卡牌目标不能为空！")
	if not needs_target():
		selected_cha = caster
	for effect_id: StringName in _model.effects:
		#TODO 需要根据条件获取目标
		Effect.try_execute(effect_id, caster, [selected_cha])
	# 消耗能量
	caster.use_energy(_model.cost)
	await caster.play_animation_with_reset(_model.play_animation)
	await caster.play_animation_with_reset("idle")

## 获取卡牌类型名
func get_card_type_name() -> String:
	return _model.get_card_type_name()

func _to_string() -> String:
	return card_name
