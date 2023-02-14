extends CharacterBody3D

@export var SPEED : float = 2
@export var JUMP_VELOCITY : float = 5
@export var GRAVITY : float = 10
@export var MOUSE_SENSITIVITY : float = 100
var currentFallSpeed
@onready var camera : Camera3D = $Camera3D
@onready var flare = preload("res://player/flare.tscn")
var direction
var mouseMotion : Vector2
var shootTimer = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	currentFallSpeed = GRAVITY

func _physics_process(delta):
	#print(1/delta)
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
		
#		if Input.is_action_just_pressed("jump"):
#			jumped = jump()


	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	mouseMotion = Vector2()


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
