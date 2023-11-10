extends Node2D

var list=[] #数组，用来保存20节小箭头

@onready var t_arrow_head = preload("res://asserts/widgets/right.png")
@onready var t_arrow_body = preload("res://asserts/widgets/fightJ.png")
const arrow_num = 15

func _ready():
	# 生成19节尾巴小箭头，用箭头1的图片
	for i in range(arrow_num - 1):
		var sprite= Sprite2D.new()    #新建 Sprite 节点
		add_child(sprite)          #添加到场景里
		list.append(sprite)        #添加到数组里
		sprite.texture = t_arrow_body #把图片换成箭头1
		sprite.scale=Vector2(1,1) * (0.2 + float(i)/18*0.8) #改变缩放，根据杀戮尖塔，箭头是一节节越来越大的
		sprite.offset=Vector2(-25,0)  #由于我画的图片中心点在箭头中间，
	# 这里改变一下图片偏移，把图片中心点移动到箭头头部
	# 最后生成终点的箭头，用箭头2的图片
	var sprite= Sprite2D.new()   
	add_child(sprite)
	list.append(sprite)
	sprite.texture = t_arrow_head
	sprite.offset=Vector2(-25,0)

func reset(startPos,endPos):
	self.show()
	#根据传入的起点和终点来计算两个控制点
	var ctrlAPos=Vector2()
	var ctrlBPos=Vector2()
	ctrlAPos.x=startPos.x+(startPos.x-endPos.x)*0.1 #这里我把参数做了微调，感觉这样更加符合杀戮尖塔的效果
	ctrlAPos.y=endPos.y-(endPos.y-startPos.y)*0.2
	ctrlBPos.y=endPos.y+(endPos.y-startPos.y)*0.3
	ctrlBPos.x=startPos.x-(startPos.x-endPos.x)*0.3
	#根据贝塞尔曲线重新设置所有小箭头的位置
	for i in range(arrow_num):
		var t=float(i)/(arrow_num - 1) 
		var pos=startPos*(1-t)*(1-t)*(1-t)+3*ctrlAPos*t*(1-t)*(1-t)+3*ctrlBPos*t*t*(1-t)+endPos*t*t*t
		list[i].position=pos 
	#虽然更改了箭头的位置，不过还需要重新计算箭头的方向   
	update_angle()   #重新计算所有箭头的方向

## 更新箭头显示
func update_angle():
	for i in range(arrow_num):
		if i==0:
			list[0].rotation_degrees=270    #第一个小箭头就让他固定朝上好了
		else:
			var current=list[i]    #当前的小箭头
			var last=list[i-1]     #前一个小箭头
			var lenVec=current.position-last.position      #两个箭头连线的向量
			var a=lenVec.angle()       #计算这个向量的角度，这个 angle()返回值是弧度
			a=rad_to_deg(a)               #弧度转成角度
			
			current.rotation_degrees=a #更新小箭头的方向

func selected() -> void:
	self.modulate = Color.DARK_RED

func unselected() -> void:
	self.modulate = Color.WHITE
