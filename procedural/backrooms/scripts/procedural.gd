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

var toDelete = []
var toAdd = []

var size = 20
var noiseScale
var timer = 0
var noise :FastNoiseLite
var player
@onready var addthread : Thread = Thread.new()
@onready var delthread : Thread = Thread.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("player")
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_VALUE
	noise.seed = 3
	noise.fractal_lacunarity = .1
	noise.fractal_gain = .8
	noise.frequency = 0.02
	seed(noise.seed)
	noiseScale = (parts.size()*10)/2;
	generate()

func _process(delta):
	timer += delta
	nextAdd()
	if timer > .25:
		if !addthread.is_alive():
			addthread.wait_to_finish()
			addthread.start(generate)
		#generate()
		if !delthread.is_alive():
			delthread.wait_to_finish()
			delthread.start(deleteOutOfRange)
		#deleteOutOfRange()
		timer = 0
#		print(player.position)

func deleteOutOfRange():
	for tile in tiles.get_children():
		if tile.position.distance_to(player.position)>size*4:
			tile.queue_free()

func generate():
	player = get_node("player")
	if player:
		var pos = Vector3(round(snapped(player.position.x,4)),round(player.position.y),round(snapped(player.position.z,4)))
		var offsetx = -roundi(size/2)*4
		var offsety = -roundi(size/2)*4
		for iy in range(size):
			for ix in range(size):
				var x = (ix*4)+pos.x
				var y = (iy*4)+pos.z
				if !tiles.get_node( "{0},{1}".format([(x+offsetx),(y+offsety)]) ):
					var tmpr = -1
					var currentNoise = noise.get_noise_2dv(Vector2((x+offsetx)*noiseScale,(y+offsety)*noiseScale))
					tmpr = int(round(abs(currentNoise)*12))
					var surroundingTiles = [-1,-1,-1,-1]
					var surroundingNoise :Array = []
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x)+offsetx)*noiseScale,((y+1)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x+1)+offsetx)*noiseScale,((y)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x)+offsetx)*noiseScale,((y-1)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x-1)+offsetx)*noiseScale,((y)+offsety)*noiseScale)))*12)) )
					
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x)+offsetx)*noiseScale,((y+2)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x+2)+offsetx)*noiseScale,((y)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x)+offsetx)*noiseScale,((y-2)+offsety)*noiseScale)))*12)) )
					surroundingNoise.push_back( int(round(abs(noise.get_noise_2dv(Vector2(((x-2)+offsetx)*noiseScale,((y)+offsety)*noiseScale)))*12)) )
					
#					print(currentNoise*10)
#					print(surroundingNoise)
#					print(noiseScale)
					#light check
					if tmpr == 5:
						if surroundingNoise.count(4)<1:
							tmpr = 4
#							print("light")
					if tmpr == 4:
						if surroundingNoise.count(4)>1:
							tmpr = 5

					#more lights
					if tmpr != 4 and surroundingNoise.count(4)<2:
						if randf() > .8:
							tmpr = 4
#					print(tmpr)
					if tmpr > 5:
						tmpr = 5
					var tmppart : Node3D = parts[tmpr].instantiate()
					var tmppartposition = Vector3((x+offsetx),0,(y+offsety))
					var tmppartname = "{0},{1}".format([tmppartposition.x,tmppartposition.z])
					addToAdd(tmppart,tmppartposition,tmppartname)
				else:
					pass
	return null

## Adds node to the queue to be added to the scene
func addToAdd(node,pos,nodename):
	toAdd.push_back([node,pos,nodename])

## Adds the next entry of nodes to be added to the scene and
## removes it from the queue
func nextAdd():
#	print(toAdd.size())
	if toAdd.size() > 10:
		for i in range(10):
			var tmp = toAdd.pop_back()
			if tmp and !get_tree().get_first_node_in_group(tmp[2]):
				tiles.call_deferred("add_child",tmp[0])
				tmp[0].position = tmp[1]
				tmp[0].name = tmp[2]
				tmp[0].add_to_group(tmp[2])


## Adds node to the queue to be removed to the scene
func addToDelete():
	pass

## Deletes the next entry of nodes to be removed from the scene and
## removes it from the queue
func nextDelete():
	pass
