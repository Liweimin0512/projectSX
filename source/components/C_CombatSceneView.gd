extends Node
class_name CombatSceneView

@onready var marker_2d_1: Marker2D = %Marker2D1 # 玩家位置
@onready var marker_2d_2: Marker2D = %Marker2D2 # 预留1
@onready var marker_2d_3: Marker2D = %Marker2D3 # 预留2

## 对于Controller层的引用
@onready var enemies: Array = [
	%Marker2D4, # 怪物1
	%Marker2D5, # 怪物2
	%Marker2D6, # 怪物3
]

@export var controller : C_CombatScene

func _ready() -> void:
	controller.combat_begined.connect(_on_combat_begined)

func _on_combat_begined() -> void:
	var player = GameInstance.player
	marker_2d_1.add_child(player)
	for cha_index in range(3,6):
		## 创建怪物View
		var enemy = controller.markers[cha_index]
		if enemy != null:
			var enemy_view = _spawn_enemy(enemy)
			enemies[cha_index-3].add_child(enemy_view)

## 创建敌人
func _spawn_enemy(controller: RefCounted) -> Node:
	var enemy_view = GameInstance.create_entity("enemy")
	return enemy_view

## 玩家主动结束回合
func _on_combat_form_end_turn_pressed() -> void:
	controller.end_turn()
