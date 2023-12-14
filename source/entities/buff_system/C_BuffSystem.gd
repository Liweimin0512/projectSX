extends Node
class_name C_BuffSystem

var buffs :Array[Buff] = []

signal buff_applied

func apply_buff(buff: Buff) -> void:
	buffs.append(buff)
	buff_applied.emit(buff)

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
