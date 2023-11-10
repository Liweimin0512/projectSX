extends Resource
class_name CardModel

enum TARGET_TYPE {
	NONE,				# 未知
	SELF,				# 自身
	THEY_SIGNAL,		# 敌方单体
	THEY_ALL, 			# 敌方全体
	OUR_SIGNAL, 		# 己方单体
	OUR_ALL, 			# 己方全体
	ALL,				# 全体
	}

enum CARD_TYPE{
	NONE,				# 未知
	ATTACK,				# 攻击
	ABILITY				# 技能
}

@export var card_name : String
@export var card_type : CARD_TYPE = 0
@export var card_description := ""
@export var cost := 1
@export var icon : Texture
@export var target_type : TARGET_TYPE = 0
@export var effects: Array = []

@export var tween_speed : float = 0.2
@export var preview_scale := Vector2(1,1)
@export var preview_position := Vector2(0,10)

func _init(card_id: String) -> void:
	var data = DatatableManager.get_datatable_row("card", card_id)
	card_name = data.card_name
	card_type = data.card_type
	card_description = data.card_description
	cost = data.cost
	icon = data.icon
	target_type = data.target_type
	effects = data.effects

## 是否需要选择目标？
func needs_target() -> bool :
	match target_type:
		TARGET_TYPE.THEY_SIGNAL:
			return true
		TARGET_TYPE.OUR_SIGNAL:
			return true
		_:
			return false

## 获取目标
func get_effect_targets(owenr:Character, targets: Array[Character]) -> Array[Character]:
	match target_type:
		TARGET_TYPE.SELF:
			return [owenr]
		TARGET_TYPE.THEY_SIGNAL:
			return targets
		TARGET_TYPE.OUR_SIGNAL:
			return targets
		_:
			push_error("未知的目标，未实现！")
			return []
