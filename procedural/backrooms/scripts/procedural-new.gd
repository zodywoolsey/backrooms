extends Node3D

@onready var wall = preload('res://procedural/backrooms/wall.tscn')
@onready var wall2 = preload('res://procedural/backrooms/wall2.tscn')
@onready var wall3 = preload('res://procedural/backrooms/wall3.tscn')
@onready var wall4 = preload('res://procedural/backrooms/wall4.tscn')
@onready var ceiling = preload('res://procedural/backrooms/ceiling.tscn')
@onready var light = preload('res://procedural/backrooms/ceiling_light.tscn')
@onready var corner = preload('res://procedural/backrooms/corner.tscn')
@onready var parts : Array = [wall,wall2,wall3,wall4,light,ceiling]
@onready var tiles = $tiles

var mutex = Mutex.new()
var size = 30
var timer = 0
var player
var thread = Thread.new()
var addThread = Thread.new()
var delThread = Thread.new()
var toadd := []
var current := []
var todel := []
var manualPos :Array = [
	"16,16",
	"24,24",
	"64,8",
	"40,60"
]
var manualTiles :Array = [
	preload("res://procedural/backrooms/ball.tscn"),
	preload("res://procedural/backrooms/ball.tscn"),
	preload("res://procedural/backrooms/ball.tscn"),
	preload("res://procedural/backrooms/ball.tscn")
]

var fogfix = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	thread.start(tileManager)

func _process(delta):
#	print(current.size())
	addTile()
	if fogfix:
		Globals.setFog({'enabled':true})
		get_tree().get_first_node_in_group("mainMenu").visible = false
		Globals.UI_STATE = 2
		fogfix = false
		Globals.applySettings()
	if get_tree().get_first_node_in_group("mainMenu").visible:
		Globals.loadingProgress = remap(current.size(),0,size*size,0.0,100.0)
		if toadd.size() < 10:
#			Globals.setSDFGI({'enabled':false})
#			Globals.setSDFGI({'enabled':true})
			Globals.setFog({'enabled':false})
			fogfix = true
#	if !addThread.is_alive() and toadd.size() > 1:
#		if addThread.is_started():
#			addThread.wait_to_finish()
#		addThread.start(addTile)

func addTile():
	var go = mutex.try_lock()
	if go:
		if toadd.size() >= 10:
			for i in range(10):
				var tmp:String = toadd.pop_back()
				var tmpadd = toadd
				if tmp not in current:
					current.append(tmp)
					var x : int = tmp.split(",")[0].to_int()
					var y : int = tmp.split(",")[1].to_int()
					var tmpi : int = (tmp.replace(',','')+str(Globals.seed.hash())).to_int()
					seed(tmpi)
					var tmpr : int = randi_range(0,5)
					var tmpTile
					if manualPos.has(tmp):
						tmpTile = manualTiles[manualPos.find(tmp)].instantiate()
					else:
						tmpTile = parts[tmpr].instantiate()
					tiles.add_child(tmpTile)
					tmpTile.global_position = Vector3(x,0,y)
					tmpTile.add_to_group(tmp)
#					print('created: {0},{1} of type {2}'.format([x,y,tmpr]))
		elif toadd.size() > 0:
			for i in range(toadd.size()):
				var tmp:String = toadd.pop_back()
				var tmpadd = toadd
				var tmpcur = current
				if tmp not in tmpcur:
					tmpcur.append(tmp)
					var x : int = tmp.split(",")[0].to_int()
					var y : int = tmp.split(",")[1].to_int()
					var tmpi : int = (tmp.replace(',','')+str(Globals.seed.hash())).to_int()
					seed(tmpi)
					var tmpr : int = randi_range(0,5)
					var tmpTile = parts[tmpr].instantiate()
					tiles.add_child(tmpTile)
					tmpTile.global_position = Vector3(x,0,y)
					tmpTile.add_to_group(tmp)
#					print('created: {0},{1} of type {2}'.format([x,y,tmpr]))
		mutex.unlock()

func delTile():
	if mutex.try_lock():
		for tile in current:
			var tmp = get_tree().get_first_node_in_group(tile)
#				print(global_position.distance_to(player.global_position))
			if tmp.global_position.distance_to(player.global_position) > (size/2)*6 and tmp.global_position.distance_to(get_tree().get_first_node_in_group('handCam').global_position) > (size/2)*4:
				tmp.queue_free()
				current.remove_at(current.find(tile))
		mutex.unlock()

func tileManager():
	while true:
		delTile()
		var playerpos = player.global_position
		for a in range(size):
			var x = snappedi(int(((a-(size/2))*4)+playerpos.x),4)
			for b in range(size):
				var y = snappedi(int(((b-(size/2))*4)+playerpos.z),4)
				var tmpname = "{0},{1}".format([x,y])
				mutex.lock()
				if tmpname not in toadd and tmpname not in current:
					toadd.append(tmpname)
				mutex.unlock()
