extends Character
class_name Enemy

var _enemy_model : EnemyModel

@onready var intent_status: MarginContainer = %IntentStatus
@onready var c_intent_system: C_IntentSystem = %C_IntentSystem
@onready var w_tooltip: MarginContainer = %w_tooltip

@export var can_attack := true

signal enemy_turn_end

func _ready() -> void:
	super()
	_enemy_model = EnemyModel.new(cha_id)
	c_intent_system.init_intent_pool(_enemy_model.intent_pool)
	area_2d.mouse_entered.connect(
		func() -> void:
			show_tooltip()
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			w_tooltip.hide()
	)

## 决策意图
func choose_intent() -> void:
	var intent : Intent = c_intent_system.choose_intent()
	intent_status.set_status(intent)

## 执行意图
func execute_intent() -> void:
	c_intent_system.execute_intent()

## 在玩家回合开始时初始化意图
func on_player_turn_begined() -> void:
	choose_intent()

## 显示意图
func show_tooltip() -> void:
	w_tooltip.set_tooltip(
		c_intent_system.current_intent.intent_name,
		c_intent_system.current_intent.description
	)
	w_tooltip.show()

func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("idle")
	var player = GameInstance.player
	player.damage(5)

## 回合开始时
func _begin_turn() -> void:
	await intent_status.execute_intent()
	intent_status.hide()
	print("敌人攻击")
	attack()
	enemy_turn_end.emit()

## 回合结束时
func _end_turn() -> void:
	intent_status.show()
