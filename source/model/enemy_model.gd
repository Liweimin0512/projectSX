extends Resource
class_name EnemyModel

var intent_pool : PackedStringArray = []

func _init(enemy_id: String) -> void:
	var data := DatatableManager.get_datatable_row("monster", enemy_id)
	intent_pool = data.intent_pool
