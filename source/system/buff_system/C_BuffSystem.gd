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

func _on_turn_begined() -> void:
	for buff: Buff in buffs:
		if buff.buff_type == Buff.BUFF_TYPE.VALUE and buff.duration_type == Buff.DURATION_TYPE.TURN:
			_remove_buff(buff)

func _on_turn_ended() -> void:
	for buff in buffs:
		if buff.is_stacked and buff.buff_type == Buff.BUFF_TYPE.STATUS:
			buff.value -= 1
			if buff.value <= 0:
				_remove_buff(buff)

## 应用buff
func apply_buff(new_buff: Buff) -> void:
	var buff: Buff
	if new_buff.is_stacked:
		for b in buffs:
			if b.can_stacked(new_buff):
				b.stack(new_buff)
				buff = b
	if not buff:
		_add_buff(new_buff)
		buff_applied.emit(new_buff)
		buff = new_buff

## 是否存在BUFF
func has_buff(buff_name: StringName) -> bool:
	var bs : Array = buffs.filter(
		func(buff: Buff) -> bool:
			return buff.buff_id == buff_name
	)
	return false if bs.is_empty() else true

## 增添BUFF
func _add_buff(buff: Buff) -> void:
	buffs.append(buff)

## 移除BUFF
func _remove_buff(buff: Buff) -> void:
	buffs.erase(buff)
