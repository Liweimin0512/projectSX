extends Control

@onready var lab_name: Label = %lab_name
@onready var lab_description: Label = %lab_description

func _ready() -> void:
	self.hide()

func set_tooltip(name: String, des: String) -> void:
	lab_name.text = name
	lab_description.text = des
