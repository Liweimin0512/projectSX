extends Node2D
class_name Character

@onready var health_label: Label = %health_label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D
@onready var c_buff_system: C_BuffSystem = $C_BuffSystem
@onready var w_health_bar: W_HealthBar = %w_health_bar

## 当前角色的类型，包括Player和Enemy
@export var cha_type: String = ""
## 当前角色的ID，用来加载Model
var cha_id: StringName
## 当前角色的数据层的实例
var _model: CharacterModel

## 当前生命值
var current_health: float:
	set = _readonly,
	get = _current_health_getter
## 最大生命值
var max_health: float:
	set = _readonly,
	get = _max_health_getter
## 护盾值
var shielded: int:
	get = _shielded_getter,
	set = _readonly
## 是否死亡
var is_death : bool = false:
	get:
		return current_health <= 0
## 是否选中
var is_selected : bool = false

## 回合开始
signal turn_begined
## 回合结束
signal turn_completed
## 受到伤害
signal damaged
## 护盾改变
signal shielded_changed
## 死亡
signal died

func _ready() -> void:
	area_2d.mouse_entered.connect(
		func() -> void:
			EventBus.push_event("character_mouse_entered", self)
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			EventBus.push_event("character_mouse_exited", self)
	)
	c_buff_system.buff_applied.connect(
		func(buff: Buff) -> void:
			w_health_bar.add_buff_widget(buff)
	)

## 开始战斗
func _begin_combat() -> void:
	w_health_bar.update_display(current_health, max_health, shielded)

## 结束战斗
func _end_combat() -> void:
	pass

## 回合开始时
func _begin_turn() -> void:
	_model.shielded = 0
	w_health_bar.update_display(current_health, max_health, shielded)

## 回合结束时
func _end_turn() -> void:
	pass

## 添加护盾
func add_shielded(value: int) -> void:
	_model.shielded += value
	shielded_changed.emit()
	w_health_bar.update_display(current_health, max_health, shielded)

## 受到伤害
func damage(damage: Damage) -> void:
	if self.is_death: 
		push_error("无法攻击尸体！")
		return
	c_buff_system.before_damage(damage)
	if shielded >= damage.value:
		_model.shielded -= damage.value
	else:
		damage.value -= shielded
		_model.current_health -= damage.value
		_model.shielded = 0
	c_buff_system.after_damage(damage)
	if current_health <= 0:
		_model.current_health = 0
		death()
	else:
		await play_animation_with_reset("hurt")
		print("受到伤害：", damage)
		play_animation_with_reset("idle")
	damaged.emit()
	w_health_bar.update_display(current_health, max_health, shielded)

## 死亡
func death() -> void:
	await play_animation_with_reset("death")
	died.emit()

## 播放动画（播放前先Reset）
func play_animation_with_reset(animation_name: StringName) -> void:
	if animation_player.has_animation("RESET"):
		animation_player.play("RESET")
	await animation_player.animation_finished
	animation_player.play(animation_name)
	await animation_player.animation_finished

## 选中
func selected() -> void:
	is_selected = true
	$selector.show()

## 取消选中
func unselected() -> void:
	is_selected = false
	$selector.hide()

## 只读属性setter，通过断言提醒开发者赋值错误
func _readonly(value) -> void:
	assert(false, "尝试给只读属性赋值！")
## 最大生命值getter
func _max_health_getter() -> float:
	return _model.max_health
## 当前生命值getter
func _current_health_getter() -> float:
	return _model.current_health
## 护盾值getter
func _shielded_getter() -> float:
	return _model.shielded
