extends Node
class_name S_Datatable

var thread := Thread.new()

@export var datatable_path : String = "res://datatables/"
var _datatable_dics : Dictionary = {}
var can_async : bool = ["Window", "OSX", "UWP", "X11"].has(OS.get_name())

func threaded_load(datatable_name : String) -> void:
	var datatable = datatable_path + datatable_name + ".csv"
	print_debug("开始加载数据表： ", datatable)
	var data = load_datatable(datatable)
	add_datatable(datatable_name, data)
	print_debug("完成加载数据表： ", datatable_path, " 数据内容： ", data)
#	emit_signal("load_completed", datatable_name, data)
	EventBus.emit("load_datatable_completed", [datatable_name, data])

func load_datatable(datatable_path : String) -> Dictionary:
	'''
	加载数据表，格式化数据
	'''
	assert(FileAccess.file_exists(datatable_path),"文件不存在！")
	var file = FileAccess.open(datatable_path, FileAccess.READ)
	var retunr_dic : Dictionary = {}
	# TODO CSV数据解析
	var data_name = file.get_csv_line(",")
	var _dec = file.get_csv_line(",")
	var type_name = file.get_csv_line(",")
	while not file.eof_reached():
		var row_data = file.get_csv_line(",")
		var d = {}
		for i in row_data.size():
			match type_name[i]:
				"int":
					d[data_name[i]] = row_data[i].to_int() if row_data[i] != "" else 0
				"float":
					d[data_name[i]] = row_data[i].to_float() if row_data[i] != "" else 0.0
				"string":
					d[data_name[i]] = row_data[i]
				"bool":
					d[data_name[i]] = bool(row_data[i].to_int())
				"int[]":
					var res := []
					var data := row_data[i].split("*")
					for r in data:
						res.append(r.to_int())
					d[data_name[i]] = res
				"float[]":
					var res := []
					var data := row_data[i].split("*")
					for r in data:
						res.append(r.to_float())
					d[data_name[i]] = res
				"string[]":
					var res := row_data[i].split("*")
					d[data_name[i]] = [] if res.is_empty() else res
				"texture":
					# godot引擎的材质
					if row_data[i].is_empty():
						d[data_name[i]] = null
					elif ResourceLoader.exists(row_data[i]):
						d[data_name[i]] = ResourceLoader.load(row_data[i]) as Texture
					else:
						assert(false, "未知的材质数据： " + row_data[i])
				_:
					assert(false,"未知的配置表数据类型: " + type_name[i])
		if not d.is_empty():
			retunr_dic[d["ID"]] = d
	return retunr_dic


func add_datatable(datatable_name : String, data : Dictionary) -> void:
	'''
	添加数据表
	'''
	_datatable_dics[datatable_name] = data

func get_datatable_row(datatable : String, row_id : String) -> Dictionary:
	'''
	获取数据表行
	'''
	if not _datatable_dics.has(datatable) or not _datatable_dics[datatable].has(row_id):
		printerr("can not found data by row id: ", row_id, " in datatable: ", datatable)
		return {}
	var row : Dictionary = _datatable_dics[datatable][row_id]
	return row

func get_datatable_all(datatable : String) -> Dictionary:
	'''
	获取数据表全部数据
	'''
	if not _datatable_dics.has(datatable):
		printerr("can not found datatable: ", datatable)
		return {}
	return _datatable_dics[datatable]
