extends Character
class_name Player

var player_data: PlayerModel

func _init(player_id: StringName) -> void:
	super(player_id)
	player_data = PlayerModel.new(player_id)
	self.add_component(CardManager.new(player_id))

## 回合开始时
func begin_turn() -> void:
	var card_manager = self.get_component("CardManager")
	card_manager.distribute_card()

## 结束回合
func end_turn() -> void:
	print("结束玩家回合")
