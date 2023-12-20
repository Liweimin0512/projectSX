extends Character
class_name Player

@onready var c_card_system: C_CardSystem = %C_CardSystem

## 释放卡牌的能量
var current_energy: int = 0: get = _current_energy_getter, set = _readonly
## 最大能量值
var max_energy : int = 0: get = _max_energy_getter, set = _readonly
## 拥有的货币数量
var coin: int = 0: get = _coin_getter, set = _readonly

## 当前能量值发生改变
signal energy_changed

func _ready() -> void:
	_model = PlayerModel.new(cha_id)
	c_card_system.init(cha_id)
	super()

## 开始战斗
func _begin_combat() -> void:
	super()
	animation_player.play("swrd_drw")
	await animation_player.animation_finished
	animation_player.play("idle_02")

## 结束战斗
func _end_combat() -> void:
	pass

## 回合开始时
func _begin_turn() -> void:
	super()
	c_card_system.distribute_card()
	reset_energy()
	turn_begined.emit()

## 结束回合
func _end_turn() -> void:
	c_card_system.discard_all()
	turn_completed.emit()

## 扣除能量的方法
func use_energy(amount: int) -> void:
	_model.current_energy -= amount
	energy_changed.emit()

## 重置当前能量值为最大
func reset_energy() -> void:
	_model.current_energy = max_energy
	energy_changed.emit()

## 只读属性setter，通过断言提醒开发者赋值错误
func _readonly(value) -> void:
	assert(false, "尝试给只读属性赋值！")
func _current_energy_getter() -> int:
	return _model.current_energy
func _max_energy_getter() -> int:
	return _model.max_energy
func _coin_getter() -> int:
	return _model.coin
