extends UIForm

@onready var lab_power: Label = %lab_power
@onready var btn_end_turn: Button = %btn_end_turn
@onready var card_container: Control = %CardContainer
@onready var turn_begin: MarginContainer = %turn_begin
@onready var lab_turn_begin: Label = %lab_turn_begin

var combat_scene : CombatScene
var player : Player 
var current_turn_cha: Character

signal end_turn_pressed

func _ready() -> void:
	btn_end_turn.pressed.connect(
		func() -> void:
			end_turn_pressed.emit()
	)
	player = GameInstance.player
	player.energy_changed.connect(
		func() -> void:
			display_energy()
	)
	display_energy()
	card_container.drag_started.connect(
		func(card: W_Card) -> void:
			btn_end_turn.disabled = true
	)
	card_container.drag_ended.connect(
		func() -> void:
			btn_end_turn.disabled = false
	)

## 回合改变
func next_turn(cha: Character) -> void:
	if cha is Player:
		await begin_player_turn()
	elif current_turn_cha is Player:
		await begin_enemy_turn()
	current_turn_cha = cha

## 开始玩家回合
func begin_player_turn() -> void:
	await show_turn_begin("玩家回合")
	btn_end_turn.text = "结束回合"
	btn_end_turn.disabled = false

## 开始敌人回合
func begin_enemy_turn() -> void:
	await show_turn_begin("敌人回合")
	btn_end_turn.text = "敌人回合"
	btn_end_turn.disabled = true

## 更新显示能量
func display_energy() -> void:
	lab_power.text = str(player.current_energy) + "/" + str(player.max_energy)

## 显示回合开始提示
func show_turn_begin(text: String) -> void:
	turn_begin.show()
	lab_turn_begin.text = text
	turn_begin.modulate.a = 0
	var tween : Tween = create_tween()
	tween.tween_property(turn_begin, "modulate:a", 1.0, 0.5)
	tween.tween_property(turn_begin, "modulate:a", 0.0, 1)
	await tween.finished
	turn_begin.hide()
