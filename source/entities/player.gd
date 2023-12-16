extends Character
class_name Player

var _player_model : PlayerModel
@onready var c_card_system: C_CardSystem = %C_CardSystem
## 释放卡牌的能量
var current_energy: int = 0:
	get:
		return _player_model.current_energy
	set(value):
		_player_model.current_energy = value
var max_energy : int = 0:
	get:
		return _player_model.max_energy
	set(value):
		_player_model.max_energy = value

var coin: int = 0:
	get:
		return _player_model.coin
	set(value):
		_player_model.coin = value

signal energy_changed

func _ready() -> void:
	super()
	_player_model = PlayerModel.new(cha_id)
	c_card_system.component_init(cha_id)

## 开始战斗
func _begin_combat() -> void:
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
	current_energy = max_energy
	turn_begined.emit()

## 结束回合
func _end_turn() -> void:
	#print("结束玩家回合")
	c_card_system.discard_all()
	turn_completed.emit()

# 扣除能量的方法
func use_energy(amount: int) -> void:
	current_energy -= amount
	energy_changed.emit()
