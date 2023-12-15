extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damage = Damage.new(10)
	var buff = buff.new()
	print(damage.value)
	buff.before_damage(damage)
	print(damage.value)

class buff:
	func before_damage(damage: Damage) ->void:
		damage.value += 1
