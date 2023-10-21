extends Character
class_name Enemy

func init(enemy_id: String) -> void:
	var data := DatatableManager.get_datatable_row("monster", enemy_id)
	max_health = data.health_points
	attack = data.attack_points
