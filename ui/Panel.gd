extends Panel
@onready var label = $Label
@onready var control = $".."

var targetpos : Vector2

func _process(delta):
	size = label.size*1.1
	control.custom_minimum_size = size
	if targetpos != null:
		position.x = lerpf(position.x,targetpos.x,.1)
		position.y = lerpf(position.y,targetpos.y,.1)

func _ready():
	var t = get_tree().create_timer(20)
	t.timeout.connect(func():
		print('done')
		control.queue_free()
		)
	targetpos = position
	position = Vector2(-(size.x+10),position.y)
