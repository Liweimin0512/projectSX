extends Node
class_name C_IntentSystem

# 意图管理器组件

## 存储所有可能的意图
var intent_pool: Array = []
## 当前选定的意图
var current_intent: Intent = null

## 意图选中
signal intent_choosed
## 意图执行
signal intent_executed

func _ready() -> void:
	randomize()

## 初始化意图池
func init_intent_pool(data: Array) -> void:
	for intentID in data:
		var intent = Intent.new(owner, intentID)
		intent_pool.append(intent)

## 更新所有意图的冷却时间
func update_cooldowns():
	for intent in intent_pool:
		intent.process_cooldown()

## 选择意图的逻辑
func choose_intent() -> void:
	var available_intents := intent_pool.filter(
		func(intent: Intent):
			return intent.is_available
	)
	if available_intents.is_empty() : 
		current_intent =  null
	var total_weight : float = available_intents.reduce(
		func(a, b): 
			return a + b.weight, 
		0
		)
	# 基于权重随机选择意图
	var random_choice = randf_range(0, total_weight)
	var accumulated_weight = 0	
	for intent: Intent in available_intents:
		accumulated_weight += intent.weight
		if random_choice <= accumulated_weight:
			current_intent = intent
			break
	intent_choosed.emit(current_intent)
	#print(owner, "筛选意图：", current_intent)

# 执行当前意图
func execute_intent():
	if not current_intent:
		push_error("执行意图时不存在，重新选择意图")
		return
	await current_intent.execute()
	update_cooldowns()
	intent_executed.emit()
