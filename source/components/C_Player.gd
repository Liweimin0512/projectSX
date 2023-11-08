extends Node
class_name C_Player

const component_name : StringName = "C_Player"

var _model : PlayerModel
var player_data: PlayerModel

func _init(player_id: StringName) -> void:
	_model = PlayerModel.new(player_id)

## 回合开始时
func begin_turn() -> void:
	var card_manager = owner.get_component("CardManager")
	card_manager.distribute_card()

## 结束回合
func end_turn() -> void:
	print("结束玩家回合")
