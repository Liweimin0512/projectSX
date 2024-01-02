extends Character
class_name Enemy

@onready var c_intent_system: C_IntentSystem = %C_IntentSystem
@onready var w_tooltip: MarginContainer = %w_tooltip

func _ready() -> void:
	super()
	_model = EnemyModel.new(cha_id)
	c_intent_system.init_intent_pool(_model.intent_pool)
	area_2d.mouse_entered.connect(
		func() -> void:
			if _is_selected: return
			show_tooltip()
	)
	area_2d.mouse_exited.connect(
		func() -> void:
			w_tooltip.hide()
	)
	GameInstance.player.turn_begined.connect(
		func() -> void:
			c_intent_system.choose_intent()
	)

## 回合开始时
func _begin_turn() -> void:
	super()
	await c_intent_system.execute_intent()
	turn_begined.emit()

## 回合结束时
func _end_turn() -> void:
	turn_completed.emit()

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

func _to_string() -> String:
	return self._model.cha_name
