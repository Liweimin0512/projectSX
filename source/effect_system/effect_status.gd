extends Effect
class_name EffectStatus

## 卡牌特性
enum CARD_STATUS_TYPE{
	NONE,		  # 未知特性
	VULNERABLE,   # 易伤
	WEAK,         # 弱化
	POISONED,     # 中毒
	BURNING,      # 燃烧
	STRENGTHENED, # 强化
	REGENERATING, # 再生
	BLEEDING,     # 流血
	ENERGIZED,    # 充能
	FROZEN        # 冻结
}

var card_status : CARD_STATUS_TYPE = CARD_STATUS_TYPE.NONE
var value := 0

func _init(data: Dictionary, caster: Character, targets: Array[Character]) -> void:
	super(data, caster, targets)
	match get_card_status(data.effect_parameters[0]):
		CARD_STATUS_TYPE.VULNERABLE:
			print("易伤")
		_:
			push_error("未知的卡牌特性，请重试")
	value = data.effect_parameters[1]

func get_card_status(status_name) -> CARD_STATUS_TYPE:
	for type_name in CARD_STATUS_TYPE.keys():
		if status_name == type_name:
			return CARD_STATUS_TYPE[type_name]
	return CARD_STATUS_TYPE.NONE
