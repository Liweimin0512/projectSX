extends Node

## 推送事件
func push_event(destination: String, payload) -> void:
		if not payload is Array:
			payload = [payload]
		payload.insert(0, _get_destination_signal(destination))
		callv("emit_signal", payload)

## 订阅事件
func subscribe(destination: String, callback: Callable) -> void:
	var dest_signal: String = _get_destination_signal(destination)
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		connect(dest_signal, callback)

## 取消订阅事件
func unsubscribe(destination: String, callback: Callable) -> void:
	var dest_signal: String = _get_destination_signal(destination)
	if is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		disconnect(dest_signal, callback)

## 获取事件名
func _get_destination_signal(destination: String) -> String:
	var dest_signal: String = "EventBus|%s" % destination
	if not has_user_signal(dest_signal):
		add_user_signal(dest_signal)
	return dest_signal
