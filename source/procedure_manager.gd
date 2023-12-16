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
		"combat": false,
		"character": false,
		"hero" : false,
		"monster" : false,
		"card" : false,
		"intent" : false,
		"buff": false,
		"ability_effect" : false,
	}
	
	func enter(msg : Dictionary = {}) -> void:
		DatatableManager.load_completed.connect(_on_load_completed)
		DatatableManager.load_datatables(datatable_paths.keys())

	func exit() -> void:
		DatatableManager.load_completed.disconnect(_on_load_completed)

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
	func enter(msg : Dictionary = {}) -> void:
		agent.begin_game()

func _ready() -> void:
	self.add_state(PROCEDURE_TYPE.LAUNCH, ProcedureLaunch.new(self))
	self.add_state(PROCEDURE_TYPE.INIT_RESOURCE, ProcedureInitResource.new(self))
	self.add_state(PROCEDURE_TYPE.BEGIN_GAME, ProcedureBeginGame.new(self))
