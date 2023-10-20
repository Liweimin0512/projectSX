extends Node2D

@onready var marker_2d_1: Marker2D = $Marker2D1 # 玩家位置
@onready var marker_2d_2: Marker2D = $Marker2D2 # 预留1
@onready var marker_2d_3: Marker2D = $Marker2D3 # 预留2
@onready var marker_2d_4: Marker2D = $Marker2D4 # 怪物1
@onready var marker_2d_5: Marker2D = $Marker2D5 # 怪物2
@onready var marker_2d_6: Marker2D = $Marker2D6 # 怪物3

## 初始化战斗场景
func init_combat() -> void:
	pass

## 开始战斗
func begin_combat() -> void:
	pass

## 开始回合
func begin_turn() -> void:
	pass

## 结束回合
func end_turn() -> void:
	pass

## 结束战斗
func end_combat() -> void:
	pass
