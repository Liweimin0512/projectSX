extends Node2D
class_name BezierArrow

@export var t_arrow_head: Texture = preload(AssetUtility.t_arrow_head_path)
@export var t_arrow_body: Texture = preload(AssetUtility.t_arrow_body_path)
@export var arrow_num = 15

func _ready():
	# 生成19节尾巴小箭头，用t_arrow_body的图片
	for i in range(arrow_num - 1):
		var sprite = Sprite2D.new()    	# 新建 Sprite 节点
		add_child(sprite)          		# 添加到场景里
		sprite.texture = t_arrow_body 	# 把图片换成箭头1
		# 改变缩放，根据《杀戮尖塔》，箭头是一节节越来越大的
		sprite.scale=Vector2(1,1) * (0.2 + float(i)/18*0.8) 
		# 由于我画的图片中心点在箭头中间
		sprite.offset=Vector2(-25,0)
		sprite.scale = sprite.scale * 0.7
	# 这里改变一下图片偏移，把图片中心点移动到箭头头部
	# 最后生成终点的箭头，用箭头2的图片
	var sprite= Sprite2D.new()   
	sprite.scale = Vector2.ONE * 0.7
	add_child(sprite)
	sprite.texture = t_arrow_head
	sprite.offset = Vector2(-25,0)

func reset(start_pos: Vector2, end_pos: Vector2):
	# 根据传入的起点和终点来计算两个控制点
	# 这里我把参数做了微调，感觉这样更加符合《杀戮尖塔》的效果
	var ctrl_a_position = Vector2(
		start_pos.x+(start_pos.x-end_pos.x)*0.1 ,
		end_pos.y-(end_pos.y-start_pos.y)*0.2
	)
	var ctrl_b_position = Vector2(
		start_pos.x-(start_pos.x-end_pos.x)*0.3,
		end_pos.y+(end_pos.y-start_pos.y)*0.3
	)
	# 根据贝塞尔曲线重新设置所有小箭头的位置
	for i in range(arrow_num):
		var t = float(i)/(arrow_num - 1)
		var b1 = pow((1-t), 3)
		var b2 =  t * pow((1-t), 2)
		var b3 = pow(t, 2) * (1-t) 
		var b4 = pow(t, 3)
		get_child(i).position = start_pos * b1 + 3 * ctrl_a_position * b2 + 3 * ctrl_b_position * b3 + end_pos * b4
	# 虽然更改了箭头的位置，不过还需要重新计算箭头的方向
	# 重新计算所有箭头的方向
	update_angle()

## 更新箭头显示
func update_angle():
	for i in range(arrow_num):
		if i==0:
			get_child(0).rotation_degrees = 270    #第一个小箭头就让他固定朝上好了
		else:
			# 当前的小箭头
			var current = get_child(i)
			# 前一个小箭头
			var last = get_child(i - 1)
			# 两个箭头连线的向量
			var len_vec = current.position - last.position      
			# 计算这个向量的角度，这个 angle()返回值是弧度
			var a=len_vec.angle()
			# 弧度转成角度
			a = rad_to_deg(a)   
			# 更新小箭头的方向
			current.rotation_degrees=a

## 高亮
func highlight() -> void:
	self.modulate = Color.DARK_RED

## 取消高亮
func unhighlight() -> void:
	self.modulate = Color.WHITE
