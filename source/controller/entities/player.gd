extends Character
class_name Player

var player_data: PlayerModel

func _init(player_id: StringName) -> void:
	super(player_id)
	player_data = PlayerModel.new(player_id)

## 回合开始时
func begin_turn() -> void:
	CardManager.distribute_card()
