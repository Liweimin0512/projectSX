extends Node2D
class_name Character

var cha_id: StringName

var _model: CharacterModel

@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

signal mouse_entered
signal mouse_exited

## 控制器引用
var current_health: float:
	get:
		return _model.current_health
	set(value):
		_model.current_health = value
		display_health_bar()

var max_health: float:
	get:
		return _model.max_health
	set(value):
		_model.max_health = value
		display_health_bar()

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
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)

func add_shielded(value: int) -> void:
	print("添加护盾：", value)

func damage(value: int) -> void:
	print("造成伤害：", value)
	await play_animation("hurt")
	current_health -= value

func play_animation(animation_name : String) -> void:
	var current_animation = animation_player.current_animation
	animation_player.play(animation_name)
	await animation_player.animation_finished
	animation_player.play(current_animation)
