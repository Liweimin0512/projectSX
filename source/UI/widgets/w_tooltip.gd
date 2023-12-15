extends Control

func _ready() -> void:
	self.hide()

func set_tooltip(name, des) -> void:
	%lab_name.text = name
	%lab_description.text = des
