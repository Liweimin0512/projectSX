extends RefCounted
class_name Card

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
var card_name: String = ""
var card_type: = 0
var card_description := ""

func _init(card_id: String) -> void:
	var data = DatatableManager.get_datatable_row("card", card_id)
	card_name = data.card_name
	card_type = data.card_type
	card_description = data.description

func is_all_target() -> bool :
	return true if target_type == TARGET_TYPE.ALL or target_type == TARGET_TYPE.OUR_ALL or target_type == TARGET_TYPE.THEY_ALL else false
