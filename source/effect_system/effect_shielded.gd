extends Effect
class_name EffectShielded

var shielded := 0
var damage: Damage

func _init(data: Dictionary, caster: Character, targets: Array) -> void:
	super(data, caster, targets)
	shielded = int(data.effect_parameters[0])

func apply() -> void:
	for target : Character in _targets:
		target.add_shielded(shielded)

func execute() -> void:
	for target : Character in _targets:
		if target.shielded >= damage.value:
			target.shielded -= damage.value
		else:
			damage.value -= target.shielded
			target.shielded = 0
