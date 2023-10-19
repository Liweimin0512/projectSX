extends Node
class_name C_Card

const component_name := "C_Card"

enum TARGET_TYPE {
	ALL,
	OUR_ALL, 
	THEY_ALL, 
	OUR_SIGNAL, 
	THEY_SIGNAL
	}

@export var target_type : TARGET_TYPE = TARGET_TYPE.ALL
@export var card_model : CardModel

func is_all_target() -> bool :
	return true if target_type == TARGET_TYPE.ALL or target_type == TARGET_TYPE.OUR_ALL or target_type == TARGET_TYPE.THEY_ALL else false
