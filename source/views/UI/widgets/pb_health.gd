extends ColorRect

@export var agent_path : NodePath
@onready var agent : Character = get_node(agent_path)

@onready var progress_bar : ProgressBar = $ProgressBar
@onready var label : Label = $Label

func _init() -> void:
	var item = self.get_canvas_item()
	RenderingServer.canvas_item_set_z_index(item, 10)

func _ready() -> void:
	await agent.ready
	label.text = agent.current_health + " / " + agent.max_health
	progress_bar.max_value = agent.max_health
	progress_bar.value = agent.current_health
	agent.health_changed.connect(self._on_health_changed)


func _on_health_changed(value : int) -> void:
	progress_bar.value = agent.current_health
