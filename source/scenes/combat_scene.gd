extends Node2D
class_name CombatScene

@onready var t_enemy := preload("res://source/entities/enemy.tscn")

@onready var marker_2d_1: Marker2D = %Marker2D1 # 玩家位置
@onready var marker_2d_2: Marker2D = %Marker2D2 # 预留1
@onready var marker_2d_3: Marker2D = %Marker2D3 # 预留2
@onready var marker_2d_4: Marker2D = %Marker2D4 # 怪物1
@onready var marker_2d_5: Marker2D = %Marker2D5 # 怪物2
@onready var marker_2d_6: Marker2D = %Marker2D6 # 怪物3

var player : PlayerCharacter = null
var enemies : Array[Enemy] = []
@onready var marker_list : Array = [
	%Marker2D1, # 玩家位置
	%Marker2D2, # 预留1
	%Marker2D3, # 预留2
	%Marker2D4, # 怪物1
	%Marker2D5, # 怪物2
	%Marker2D6, # 怪物3
]
var current_marker : int = 0

## 初始化战斗场景
func init_combat(combat_id: String) -> void:
	var data = DatatableManager.get_datatable_row("combat", combat_id)
	if not data.mark_01.is_empty():
		var enemy = _create_enemy(data.mark_01)
		marker_2d_4.add_child(enemy)
		enemies.append(enemy)
	if not data.mark_02.is_empty():
		var enemy = _create_enemy(data.mark_02)
		marker_2d_5.add_child(enemy)
		enemies.append(enemy)
	if not data.mark_03.is_empty():
		var enemy = _create_enemy(data.mark_03)
		marker_2d_6.add_child(enemy)
		enemies.append(enemy)
	if not player:
		player = get_tree().get_nodes_in_group("player")[0]
	player.get_parent().remove_child(player)
	marker_2d_1.add_child(player)
	begin_combat()

## 创建敌人
func _create_enemy(enemy_id: String) -> Character:
	var enemy := t_enemy.instantiate()
	enemy.init(enemy_id)
	return enemy

## 开始战斗
func begin_combat() -> void:
	begin_turn()

## 开始回合
func begin_turn() -> void:
	var marker: Marker2D = marker_list[current_marker]
	if marker.get_child_count() <= 0:
		current_marker += 1
		begin_turn()
		return
	var cha: Character = marker.get_child(0)
	cha.begin_turn()

## 结束回合
func end_turn() -> void:
	pass

## 结束战斗
func end_combat() -> void:
	pass
