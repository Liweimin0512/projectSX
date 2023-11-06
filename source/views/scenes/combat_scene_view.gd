extends Node2D
class_name CombatSceneView

@onready var t_player := preload("res://source/views/entities/player_view.tscn")
@onready var t_enemy := preload("res://source/views/entities/enemy_view.tscn")

@onready var marker_2d_1: Marker2D = %Marker2D1 # 玩家位置
@onready var marker_2d_2: Marker2D = %Marker2D2 # 预留1
@onready var marker_2d_3: Marker2D = %Marker2D3 # 预留2

## 对于Controller层的引用
var controller: CombatScene # 在切换场景的时候注入
@onready var enemies: Array = [
	%Marker2D4, # 怪物1
	%Marker2D5, # 怪物2
	%Marker2D6, # 怪物3
]

func _ready() -> void:
	var player_view = GameInstance.create_entity(t_player, controller.markers[0])
	marker_2d_1.add_child(player_view)
	for cha_index in range(3,6):
		## 创建怪物View
		var enemy = controller.markers[cha_index]
		if enemy != null:
			var enemy_view = _spawn_enemy(enemy)
			enemies[cha_index-3].add_child(enemy_view)


## 创建敌人
func _spawn_enemy(controller: RefCounted) -> Node:
	var enemy_view = GameInstance.create_entity(t_enemy, controller)
	return enemy_view

## 玩家主动结束回合
func _on_combat_form_end_turn_pressed() -> void:
	
	controller.end_turn()
