extends MarginContainer

@onready var label_shielded: Label = %label_shielded
@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label
@onready var shielded_container: MarginContainer = %ShieldedContainer
var box_line_red := StyleBoxLine.new()
var box_line_shielded := StyleBoxLine.new()

var _character: Character

func _ready() -> void:
	box_line_red.color = Color.RED
	box_line_red.thickness = 10
	box_line_shielded.color = Color.SKY_BLUE
	box_line_shielded.thickness = 10

func update_display() -> void:
	if not _character:
		_character = owner
	health_bar.max_value = _character.max_health
	health_bar.value = _character.current_health
	health_label.text = str(_character.current_health) + "/" + str(_character.max_health)
	if _character.shielded > 0:
		shielded_container.show()
		health_bar.add_theme_stylebox_override("fill", box_line_shielded)
		label_shielded.text = str(_character.shielded)
	else:
		shielded_container.hide()
		health_bar.add_theme_stylebox_override("fill", box_line_red)
	
