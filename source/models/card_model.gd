extends Resource
class_name CardModel

enum TARGET_TYPE {
	ALL,
	OUR_ALL, 
	THEY_ALL, 
	OUR_SIGNAL, 
	THEY_SIGNAL
	}

@export var card_name : String
var card_type: = 0
var card_description := ""
@export var target_type : TARGET_TYPE = TARGET_TYPE.ALL
@export var tween_speed : float = 0.2
@export var preview_scale := Vector2(1,1)
@export var preview_position := Vector2(0,10)

func _init(card_id: String) -> void:
	var data = DatatableManager.get_datatable_row("card", card_id)
	card_name = data.card_name
	card_type = data.card_type
	card_description = data.description

## 是否需要选择目标？
func is_all_target() -> bool :
	return true if target_type == TARGET_TYPE.ALL or target_type == TARGET_TYPE.OUR_ALL or target_type == TARGET_TYPE.THEY_ALL else false
