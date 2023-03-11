@tool
extends Marker3D

var parent :RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !parent and get_parent().is_class('RigidBody3D'):
		parent = get_parent()
	if parent:
		position = parent.center_of_mass
