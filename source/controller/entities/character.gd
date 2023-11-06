extends EntityBase
class_name Character

var cha_data: CharacterModel
signal play_begined

func _init(cha_id: StringName) -> void:
	cha_data = CharacterModel.new(cha_id)

## 开始战斗
func begin_play() -> void:
	pass

## 结束战斗
func end_play() -> void:
	pass

## 回合开始时
func begin_turn() -> void:
	pass

## 回合结束时
func end_turn() -> void:
	pass
