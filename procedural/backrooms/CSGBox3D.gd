extends CSGBox3D
@onready var player = get_tree().get_first_node_in_group("player")

func _process(delta):
	if is_instance_valid(player):
		position = Vector3( snapped(player.position.x,10), -.5 ,snapped(player.position.z,10) )
	else:
		player = get_tree().get_first_node_in_group("player")
