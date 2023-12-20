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

## 卡牌名称
@export var card_name : String
## 卡牌类型
@export var card_type : CARD_TYPE = 0
## 卡牌描述
@export var card_description := ""
## 卡牌消耗
@export var cost := 1
## 卡牌图标
@export var icon : Texture
## 目标类型
@export var target_type : TARGET_TYPE = 0
## 释放者释放卡牌时候播放的动画
@export var play_animation: String = ""
## 效果集
@export var effects: Array = []
## 词条集(用来显示）
@export var buff_des : PackedStringArray = []

func _init(card_id: String) -> void:
	if card_id.is_empty(): return
	var data = DatatableManager.get_datatable_row("card", card_id)
	card_name = data.card_name
	card_type = data.card_type
	card_description = data.card_description
	cost = data.cost
	icon = data.icon
	target_type = data.target_type
	effects = data.effects
	play_animation = data.play_animation
	buff_des = data.buff_des

## 是否需要目标
func needs_target() -> bool :
	match target_type:
		TARGET_TYPE.THEY_SIGNAL:
			return true
		TARGET_TYPE.OUR_SIGNAL:
			return true
		_:
			return false

## 获取目标
func get_targets(owenr:Character, selected_cha: Character) -> Array[Character]:
	match target_type:
		TARGET_TYPE.SELF:
			return [owenr]
		TARGET_TYPE.THEY_SIGNAL:
			return [selected_cha]
		#TARGET_TYPE.OUR_SIGNAL:
			#return targets
		_:
			push_error("未知的目标，未实现！")
			return []
