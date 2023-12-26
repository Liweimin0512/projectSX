extends CharacterModel
class_name PlayerModel

## 能量：释放卡牌用，默认初始4点
var max_energy : int = 3
var current_energy : int = max_energy
var coin : int = 0

func _init(hero_id: String) -> void:
	super(hero_id)
