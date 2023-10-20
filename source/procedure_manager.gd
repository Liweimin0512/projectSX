extends BaseStateMachine
class_name ProcedureManager

enum PROCEDURE_TYPE{
	LAUNCH,
	INIT_RESOURCE,
	BEGIN_GAME,
}

class ProcedureLaunch:
	extends BaseState

	func enter(msg : Dictionary = {}) -> void:
		transition_to(PROCEDURE_TYPE.INIT_RESOURCE)

	func exit() -> void:
		pass

class ProcedureInitResource:
	extends BaseState

	var data_system
	var datatable_paths = {
#		"ability" : false,
#		"ability_effect" : false,
#		"attribute" : false,
#		"attribute_set" : false,
#		"enemy" : false,
		"card" : false,
		"hero" : false,
	}
	
	func enter(msg : Dictionary = {}) -> void:
		EventBus.subscribe("load_datatable_completed", _on_load_completed)
		for datatable_name in datatable_paths:
			DatatableManager.threaded_load(datatable_name)

	func exit() -> void:
		EventBus.unsubscribe("load_datatable_completed", _on_load_completed)

	func update(delta : float) -> void:
		if _is_load_completed():
			transition_to(PROCEDURE_TYPE.BEGIN_GAME)

	func _on_load_completed(datatable_name : String, data : Dictionary) -> void:
		datatable_paths[datatable_name] = true

	func _is_load_completed() -> bool:
		for d in datatable_paths.values():
			if d == false:
				return false
		return true

class ProcedureBeginGame:
	extends BaseState
	var state_name : String = "ProcedureMain"
	func enter(msg : Dictionary = {}) -> void:
		print_debug("enter" + state_name)
		agent.begin_game()

func _ready() -> void:
	self.add_state(PROCEDURE_TYPE.LAUNCH, ProcedureLaunch.new(self))
	self.add_state(PROCEDURE_TYPE.INIT_RESOURCE, ProcedureInitResource.new(self))
	self.add_state(PROCEDURE_TYPE.BEGIN_GAME, ProcedureBeginGame.new(self))
