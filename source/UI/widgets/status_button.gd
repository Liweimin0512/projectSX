extends TextureButton


func _ready() -> void:
	self.pivot_offset = self.size / 2
	self.mouse_entered.connect(
		func() -> void:
			rotation_degrees = -10
	)
	self.mouse_exited.connect(
		func() -> void:
			rotation_degrees = 0
	)
