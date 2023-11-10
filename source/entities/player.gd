extends Character
class_name Player

var _player_model : PlayerModel
@onready var c_card_system: Node = %C_CardSystem

func _ready() -> void:
	super()
	_player_model = PlayerModel.new(cha_id)
	c_card_system.component_init(cha_id)

## 回合开始时
func begin_turn() -> void:
	c_card_system.distribute_card()

## 结束回合
func end_turn() -> void:
	print("结束玩家回合")
