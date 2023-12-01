extends Node2D
class_name Character

var cha_id: StringName

var _model: CharacterModel

@onready var w_health_bar = %w_health_bar
@onready var health_label: Label = %health_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

## 控制器引用
var current_health: float:
	get:
		return _model.current_health
	set(value):
		_model.current_health = value
		current_health_changed.emit(_model.current_health)
		display_health_bar()

var max_health: float:
	get:
		return _model.max_health
	set(value):
		_model.max_health = value
		display_health_bar()

## 护盾值
var shielded: int:
	get:
		return _model.shielded
	set(value):
		_model.shielded = value
		display_health_bar()

signal mouse_entered
signal mouse_exited
signal current_health_changed(value)

func _ready() -> void:
	area_2d.mouse_entered.connect(
		func() -> void:
			mouse_entered.emit()
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			mouse_exited.emit()
	)
	_model = CharacterModel.new(cha_id)
	w_health_bar._character = self
	display_health_bar()

## 开始战斗
func _begin_combat() -> void:
	pass

## 结束战斗
func _end_combat() -> void:
	pass

## 回合开始时
func _begin_turn() -> void:
	pass

## 回合结束时
func _end_turn() -> void:
	pass

func display_health_bar() -> void:
	w_health_bar.update_display()

## 添加护盾
func add_shielded(value: int) -> void:
	print("添加护盾：", value)
	shielded += value

func damage(value: int) -> void:
	print("造成伤害：", value)
	await play_animation("hurt")
	if shielded >= value:
		shielded -= value
	else:
		current_health -= (value - shielded)
		shielded = 0

func play_animation(animation_name : String) -> void:
	var current_animation = animation_player.current_animation
	animation_player.play(animation_name)
	await animation_player.animation_finished
	animation_player.play(current_animation)
