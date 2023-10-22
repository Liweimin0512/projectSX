extends Node

var current_scene = null
var HP = 3
var Score = 0
var game_main = null :
	set(value) : game_main = value
	get : return game_main

signal change_score
signal changeHP

func _ready():
	var random = RandomNumberGenerator.new()
	random.randomize()

	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	connect("change_score", self._change_score)
	connect("changeHP",self._changeHP)	

func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	
	#这个函数通常会从一个信号回调、
	#或当前场景中的其他函数中调用。此时删除当前场景不是一个好主意，
	#因为它可能仍在执行代码。这将导致崩溃或意外行为。
	#解决方案是将加载延迟到稍后的时间，此时我们可以确保当前场景中没有代码在运行
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	#现在可以安全地移除当前场景了
	current_scene.free()

	# Load the new scene.
	#加载新场景。
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	#实例化新场景。
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	#将它添加到活动场景中，作为根的子级。
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	#（可选）使其与SceneTree.change_scene（）API兼容。
	get_tree().set_current_scene(current_scene)

func _change_score(n:int):
	Score += n

func _changeHP(n : int):
	if HP <= 0:
		return	
	HP += n

## 创建实体
func create_entity(view_scene: PackedScene, controller: RefCounted) -> Node:
	var view : Node = view_scene.instantiate()
	if "controller" in view:
		view.controller = controller
	return view
