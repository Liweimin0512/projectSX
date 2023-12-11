@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_autoload_singleton("EventBus", "res://addons/li_framework/auto/event_bus.gd")
	add_autoload_singleton("DatatableManager", "res://addons/li_framework/auto/datatable_manager.gd")
	#print("li framework enter tree")

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
