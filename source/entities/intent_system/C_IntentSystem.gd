extends Node
class_name C_IntentSystem

# 意图管理器组件

# 存储所有可能的意图
var intent_pool: Array = []
# 当前选定的意图
var current_intent: Intent = null

# 初始化意图池
func init_intent_pool(data: Array) -> void:
	for intentID in data:
		var intent = Intent.new(owner, intentID)
		intent_pool.append(intent)
	
# 选择意图的逻辑
func choose_intent() -> Intent:
	# 这里可以实现一个选择意图的算法，比如随机选择或基于某些条件选择
	current_intent = intent_pool[randi() % intent_pool.size()]
	return current_intent

# 执行当前意图
func execute_intent():
	if not current_intent:
		push_error("执行意图时不存在，重新选择意图")
		return
	current_intent.execute()
