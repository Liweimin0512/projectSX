extends Node
class_name C_BuffSystem

var buffs :Array[Buff] = []

signal buff_applied

func _ready() -> void:
	owner.turn_completed.connect(_on_turn_ended)

func before_damage(damage: Damage) -> void:
	for buff in buffs:
		if buff.callback_type == Buff.CALLBACK_TYPE.BEFORE_DAMAGE:
			buff.execute_func.call(damage)

func after_damage(damage: Damage) -> void:
	for buff in buffs:
		if buff.callback_type == Buff.CALLBACK_TYPE.AFTER_DAMAGE:
			buff.execute_func.call(damage)

func _on_turn_ended() -> void:
	for buff in buffs:
		if buff.is_turn():
			buff.value -= 1
			if buff.value <= 0:
				remove_buff(buff)

## 应用buff
func apply_buff(new_buff: Buff) -> void:
	var buff_found = false
	if new_buff.is_stacked:
		for buff in buffs:
			if buff.can_stacked(new_buff):
				buff.stack(new_buff)
			buff_found = true
	if not buff_found:
		buffs.append(new_buff)
		buff_applied.emit(new_buff)

func has_buff(buff_name: StringName) -> bool:
	var bs : Array = buffs.filter(
		func(buff: Buff) -> bool:
			return buff.buff_id == buff_name
	)
	return false if bs.is_empty() else true

func add_buff(buff: Buff) -> void:
	buffs.append(buff)

func remove_buff(buff: Buff) -> void:
	buffs.erase(buff)

func get_buff(index: int) -> Buff:
	return buffs[index]

func get_all_buff() -> Array[Buff]:
	return buffs

func stack_buff(buff:Buff, value: int) -> void:
	buff.stacked + value
