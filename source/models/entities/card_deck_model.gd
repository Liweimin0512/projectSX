extends Resource
class_name CardDeckModel

enum DECK_TYPE{
		DRAW,
		DISCARD
	}

var card_list : Array = []
var deck_type : DECK_TYPE = DECK_TYPE.DRAW
var deck_name : StringName = "抽牌堆"

func _init(d_name: StringName, type: int) -> void:
	deck_name = d_name
	deck_type = type
