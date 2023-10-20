extends Node

func emit(destination: String, payload) -> void:
		if not payload is Array:
			payload = [payload]
		payload.insert(0, _get_destination_signal(destination))
		callv("emit_signal", payload)

# Subscribes to a destination. callback_name is the method to be called.
func subscribe(destination: String, callback: Callable) -> void:
	var dest_signal: String = _get_destination_signal(destination)
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		connect(dest_signal, callback)

func unsubscribe(destination: String, callback: Callable) -> void:
	var dest_signal: String = _get_destination_signal(destination)
	if not is_connected(dest_signal, callback):
		# warning-ignore: return_value_discarded
		disconnect(dest_signal, callback)

func _get_destination_signal(destination: String) -> String:
	var dest_signal: String = "EventBus|%s" % destination
	if not has_user_signal(dest_signal):
		add_user_signal(dest_signal)
	return dest_signal
