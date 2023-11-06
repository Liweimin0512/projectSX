extends SceneBase
class_name CombatScene

var _model : CombatModel

var markers: Array:
	get:
		return _model.markers
var current_marker: int:
	get:
		return _model.current_marker

signal combat_begined

## 进入当前场景，开始战斗
func _enter(msg:Dictionary = {}) -> void:
	var combat_id = msg.combat_id
	begin_combat(combat_id)

## 开始战斗，战斗初始化
func begin_combat(combat_id: StringName) -> void:
	var data : Dictionary = DatatableManager.get_datatable_row("combat", combat_id)
	_model = CombatModel.new()
	markers[0] = GameInstance.player
	_create_enemy(data.mark_04, 3)
	_create_enemy(data.mark_05, 4)
	_create_enemy(data.mark_06, 5)
	begin_turn()

## 开始回合
func begin_turn() -> void:
	var cha : Character = _get_current_marker()
	if cha == null:
		_get_next_marker()
		begin_turn()
	else:
		cha.begin_turn()

## 结束回合
func end_turn() -> void:
	var cha: Character = _get_current_marker()
	cha.end_turn()
	_get_next_marker().begin_turn()

## 结束战斗
func end_combat() -> void:
	_model.free()

## 创建敌人
func _create_enemy(enemyID: StringName, markerID: int) -> void:
	if enemyID.is_empty():
		return
	var enemy : Enemy = Enemy.new(enemyID)
	enemy.combat_scene = self
	markers[markerID] = enemy

## 获取当前位置
func _get_current_marker() -> EntityBase:
	return markers[_model.current_marker]

## 获取下一个位置的角色（不为空）
func _get_next_marker() -> Character:
	if current_marker >= markers.size() -1:
		current_marker = 0
	else:
		current_marker += 1
	if _get_current_marker() == null:
		return _get_next_marker()
	return _get_current_marker()
