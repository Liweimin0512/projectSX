extends Resource
class_name CombatModel

var characters: Dictionary = {
	"marker01": null,
	"marker02": null,
	"marker03": null,
	"marker04": null,
	"marker05": null,
	"marker06": null,
}

func _init(combat_id: String) -> void:
	var data = DatatableManager.get_datatable_row("combat", combat_id)
	characters.marker04 = _get_marker_cha(data.mark_04)
	characters.marker05 = _get_marker_cha(data.mark_05)
	characters.marker06 = _get_marker_cha(data.mark_06)

func _get_marker_cha(marker: String):
	return marker if not marker.is_empty() else null
