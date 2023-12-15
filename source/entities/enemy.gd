extends Character
class_name Enemy

var _enemy_model : EnemyModel

@onready var intent_status: Control = %IntentStatus
@onready var c_intent_system: C_IntentSystem = %C_IntentSystem
@onready var w_tooltip: MarginContainer = %w_tooltip

@export var can_attack := true

#signal enemy_turn_end

func _ready() -> void:
	super()
	_enemy_model = EnemyModel.new(cha_id)
	c_intent_system.init_intent_pool(_enemy_model.intent_pool)
	intent_status.hide()
	area_2d.mouse_entered.connect(
		func() -> void:
			if is_selected: return
			show_tooltip()
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			w_tooltip.hide()
	)
	GameInstance.player.turn_begined.connect(
		func() -> void:
			choose_intent()
			intent_status.show()
	)

## 回合开始时
func _begin_turn() -> void:
	await intent_status.execute_intent()
	intent_status.hide()
	print("敌人攻击")
	#TODO 根据意图执行动作
	#attack()
	execute_intent()
	turn_begined.emit()
	#enemy_turn_end.emit()

## 回合结束时
func _end_turn() -> void:
	turn_completed.emit()

## 决策意图
func choose_intent() -> void:
	var intent : Intent = c_intent_system.choose_intent()
	if not intent:
		push_warning("没有找到合适的意图！",self)
		intent_status.hide()
		return
	intent_status.set_status(intent)
	print("筛选出意图: ", intent.intent_name)

## 执行意图
func execute_intent() -> void:
	c_intent_system.execute_intent()

## 显示意图
func show_tooltip() -> void:
	if not c_intent_system.current_intent: 
		push_warning("当前意图为空！", self)
		return
	w_tooltip.set_tooltip(
		c_intent_system.current_intent.intent_name,
		c_intent_system.current_intent.description
	)
	w_tooltip.show()

func attack() -> void:
	await play_animation_with_reset("attack")
	play_animation_with_reset("idle")
	var player = GameInstance.player
	player.damage(Damage.new(5))

func _to_string() -> String:
	return self._model.cha_name
