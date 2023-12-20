extends Resource
class_name CardDeckModel

## 牌堆类型
enum DECK_TYPE{
		DRAW,
		DISCARD
	}

## 卡牌列表
var card_list : Array = []
## 牌堆类型
var deck_type : DECK_TYPE = DECK_TYPE.DRAW
## 牌堆名称
var deck_name : StringName = "抽牌堆"
## 牌堆描述
var deck_des : String = ""

func _init(d_name: StringName, type: int, des: String) -> void:
	deck_name = d_name
	deck_type = type
	deck_des = des
