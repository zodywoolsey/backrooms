extends CSGBox3D
@onready var player = $"../player"

func _process(delta):
	position = Vector3( snapped(player.position.x,10), -.5 ,snapped(player.position.z,10) )
