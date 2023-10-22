extends Node2D
class_name CharacterView

@onready var health_bar: ProgressBar = %health_bar
@onready var health_label: Label = %health_label

## 控制器引用
var controller: Character = null ## 在创建（通常在场景中）时候被注入
var current_health: float:
	get:
		return controller.cha_data.current_health
	set(value):
		pass

var max_health: float:
	get:
		return controller.cha_data.max_health
	set(value):
		pass

func _ready() -> void:
	display_health_bar()

func display_health_bar() -> void:
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_label.text = str(current_health) + "/" + str(max_health)

func _readonly(value) -> void:
	pass
