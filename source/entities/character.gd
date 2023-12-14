extends Node2D
class_name Character

var cha_id: StringName

var _model: CharacterModel

@onready var w_health_bar = %w_health_bar
@onready var health_label: Label = %health_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var c_buff_system: C_BuffSystem = $C_BuffSystem

@export var cha_type: String = ""

## 控制器引用
var current_health: float:
	get:
		return _model.current_health
	set(value):
		_model.current_health = value
		current_health_changed.emit(_model.current_health)
		_display_health_bar()

var max_health: float:
	get:
		return _model.max_health
	set(value):
		_model.max_health = value
		_display_health_bar()

## 护盾值
var shielded: int:
	get:
		return _model.shielded
	set(value):
		_model.shielded = value
		_display_health_bar()

var is_death : bool = false

var is_selected : bool = false

#signal mouse_entered
#signal mouse_exited
signal current_health_changed(value)

signal turn_begined
signal turn_completed

func _ready() -> void:
	area_2d.mouse_entered.connect(
		func() -> void:
			EventBus.push_event("character_mouse_entered", self)
			#mouse_entered.emit()
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			EventBus.push_event("character_mouse_exited", self)
			#mouse_exited.emit()
	)
	_model = CharacterModel.new(cha_id)
	w_health_bar._character = self
	_display_health_bar()

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

## 添加护盾
func add_shielded(value: int) -> void:
	#print("添加护盾：", value)
	shielded += value

## 受到伤害
func damage(value: int) -> void:
	#print("受到伤害：", value)
	var damage : int = value
	if c_buff_system.has_buff("vulnerable"):
		damage *= 1.5
	await play_animation_with_reset("hurt")
	if shielded >= damage:
		shielded -= damage
	else:
		current_health -= (damage - shielded)
		shielded = 0
	if current_health<= 0:
		current_health = 0
		death()
		return
	print("受到伤害：", damage)
	await play_animation_with_reset("idle")

## 死亡
func death() -> void:
	await play_animation_with_reset("death")
	is_death = true

## 更新血条显示
func _display_health_bar() -> void:
	w_health_bar.update_display()

func play_animation_with_reset(animation_name: StringName) -> void:
	if animation_player.has_animation("RESET"):
		animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play(animation_name)
	await animation_player.animation_finished

func selected() -> void:
	is_selected = true
	$selector.show()

func unselected() -> void:
	is_selected = false
	$selector.hide()
