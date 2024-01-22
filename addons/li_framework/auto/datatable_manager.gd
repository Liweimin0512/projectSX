extends Node
class_name S_Datatable

@export var datatable_path : String = "res://datatables/"
var _datatable_dics : Dictionary = {}

@export var can_async : bool = true
var thread := Thread.new()

signal load_completed(datatable_name: String, data: Dictionary)

func _exit_tree() -> void:
	thread.wait_to_finish()

func load_datatables(names: PackedStringArray) -> void:
	if can_async:
		thread.start(_load_datatables.bind(names))
		var ret = thread.wait_to_finish()
		for name in names:
			var data = ret[name]
			load_completed.emit(name, data)
	else:
		_load_datatables(names)

func _load_datatables(names: PackedStringArray) -> Dictionary:
	var ret_dic : Dictionary
	for datatable_name in names:
#		print_debug("开始加载数据表： ", datatable_name)
		ret_dic[datatable_name] = _load_datatable(datatable_name)
#		print_debug("完成加载数据表： ", datatable_name, ret_dic[datatable_name])
		emit_signal("load_completed", datatable_name, ret_dic[datatable_name])
	return ret_dic

func _load_datatable(datatable_name : String) -> Dictionary:
	'''
	加载数据表，格式化数据
	'''
	var datatable = datatable_path + datatable_name + ".csv"
	assert(FileAccess.file_exists(datatable), "文件不存在！")
	var file = FileAccess.open(datatable, FileAccess.READ)
	var return_dic : Dictionary = {}
	# TODO CSV数据解析
	var data_name : PackedStringArray = file.get_csv_line(",")
	var _dec : PackedStringArray = file.get_csv_line(",")
	var type_name : PackedStringArray = file.get_csv_line(",")
	while not file.eof_reached():
		var row_data : PackedStringArray = file.get_csv_line(",")
		var d = {}
		for i in row_data.size():
			var _d_name : StringName = data_name[i]
			match type_name[i]:
				"int":
					d[_d_name] = row_data[i].to_int() if row_data[i] != "" else 0
				"float":
					d[_d_name] = row_data[i].to_float() if row_data[i] != "" else 0.0
				"string":
					d[_d_name] = row_data[i]
				"bool":
					d[_d_name] = bool(row_data[i].to_int())
				"int[]":
					var res := []
					var data := row_data[i].split("*")
					for r in data:
						res.append(r.to_int())
					d[_d_name] = res
				"float[]":
					var res := []
					var data := row_data[i].split("*")
					for r in data:
						res.append(r.to_float())
					d[_d_name] = res
				"string[]":
					if row_data[i].is_empty():
						d[_d_name] = []
					else:
						var res := row_data[i].split("*")
						d[_d_name] = [] if res.is_empty() else res
				"texture":
					# godot引擎的材质
					if row_data[i].is_empty():
						d[_d_name] = null
					elif ResourceLoader.exists(row_data[i]):
						d[_d_name] = ResourceLoader.load(row_data[i]) as Texture
					else:
						assert(false, "未知的材质数据： " + row_data[i])
				_:
					if type_name[i].is_empty():
						push_warning("数据表:", datatable_path," 数据类型为空:", _d_name)
						d[_d_name] = row_data[i]
					else:
						assert(false,"未知的配置表数据类型: " + type_name[i])
		if not d.is_empty():
			return_dic[StringName(d["ID"])] = d
	add_datatable(datatable_name, return_dic)
	load_completed.emit(datatable_name, return_dic)
	return return_dic

func add_datatable(datatable_name : String, data : Dictionary) -> void:
	'''
	添加数据表
	'''
	_datatable_dics[datatable_name] = data

func get_datatable_row(datatable : StringName, row_id : StringName) -> Dictionary:
	'''
	获取数据表行
	'''
	if not _datatable_dics.has(datatable) or not _datatable_dics[datatable].has(row_id):
		printerr("can not found data by row id: ", row_id, " in datatable: ", datatable)
		return {}
	var row : Dictionary = _datatable_dics[datatable][row_id]
	return row

func get_datatable_all(datatable : StringName) -> Dictionary:
	'''
	获取数据表全部数据
	'''
	if not _datatable_dics.has(datatable):
		printerr("can not found datatable: ", datatable)
		return {}
	return _datatable_dics[datatable]
