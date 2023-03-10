extends CharacterBody3D

@export var SPEED : float = 2
@export var JUMP_VELOCITY : float = 5
@export var GRAVITY : float = 10
@export var MOUSE_SENSITIVITY : float = 100
@export var HEADBOB_INTENSITY : float = 0.01
var hbi
@export var HEADBOB_SPEED : float = 1.0
var hbs
var currentFallSpeed
@onready var camera : Camera3D = $cameraParent/Camera3D
@onready var camera_parent = $cameraParent
@onready var flare = preload("res://player/flare.tscn")
var direction
var mouseMotion : Vector2
var shootTimer = 0
@onready var hand = $cameraParent/Camera3D/hand

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	currentFallSpeed = GRAVITY
	hbs = HEADBOB_SPEED
	hbi = HEADBOB_INTENSITY

func _physics_process(delta):
	#print(1/delta)
	var currentspeed = SPEED
	shootTimer += delta
	var input_dir = Vector2()
	direction = Vector3()
	var jumped = false
	if not is_on_floor():
		velocity.y -= currentFallSpeed * delta
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
#		if Input.is_action_just_pressed("ui_cancel"):
#			Globals.UI_STATE = 1
			
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
		
		if Input.is_action_just_pressed("jump"):
			jumped = jump()
	
	
	if direction:
		if Input.is_action_pressed("run"):
			currentspeed*=2.0
			hbs = HEADBOB_SPEED*16.0
			hbi = HEADBOB_INTENSITY*2.0
		else:
			hbs = HEADBOB_SPEED*8.0
			hbi = HEADBOB_INTENSITY*1.5
		velocity.x = direction.x * currentspeed
		velocity.z = direction.z * currentspeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentspeed)
		velocity.z = move_toward(velocity.z, 0, currentspeed)
		hbs = HEADBOB_SPEED
		hbi = HEADBOB_INTENSITY
	
	if Input.is_action_just_pressed('shoot') and global_position.distance_to(hand.pickedObject.global_position) < 3:
		hand.placed = !hand.placed
	if Input.is_action_just_released("zoomout"):
		if hand.pickedObject.is_in_group('handCamBody'):
			if get_tree().get_first_node_in_group('handCam').fov < 110:
				get_tree().get_first_node_in_group('handCam').fov += 5
	if Input.is_action_just_released("zoomin"):
		if hand.pickedObject.is_in_group('handCamBody'):
			if get_tree().get_first_node_in_group('handCam').fov > 10:
				get_tree().get_first_node_in_group('handCam').fov -= 5
	
	
	move_and_slide()
	mouseMotion = Vector2()
	camera_parent.position = lerp(Vector3(0,.5-hbi,0),Vector3(0,.5+hbi,0),sin(Time.get_unix_time_from_system()*hbs))


func _input(event):
	if event is InputEventMouseMotion:
		mouseMotion = event.relative
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate(Vector3.UP, ((-mouseMotion.x/100000)*MOUSE_SENSITIVITY) )
			camera.rotate(Vector3.RIGHT, ((-mouseMotion.y/100000)*MOUSE_SENSITIVITY))
			
#	if event is InputEventMouseButton:
#		if event.pressed:
#			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func jump():
	if is_on_floor():
		velocity += Vector3(get_floor_normal().x*2,1,get_floor_normal().z*2)*JUMP_VELOCITY
		return true
	return false
