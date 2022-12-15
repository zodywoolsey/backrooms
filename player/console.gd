extends Control

@onready var input : LineEdit = $HBoxContainer/VSplitContainer/input
@onready var previous : ItemList = $HBoxContainer/VSplitContainer/previous
@onready var inputList : ItemList = $HBoxContainer/ItemList

@export var regexs : Dictionary

var previousIndex = -1
var isInputFocused = false

func _ready():
	input.connect("text_submitted", commandSubmitted)
	input.connect("focus_entered", inputFocused)
	input.connect("focus_exited", inputUnFocused)
	
	regexs["float"] = RegEx.new()
	regexs["float"].compile("(-)?(\\d*)?(\\.)?(\\d*)?$")
	regexs["bool"] = RegEx.new()
	regexs["bool"].compile("(true)|(false)$")
	
	regexs["SPEED"] = RegEx.new()
	regexs["FLOOR_DRAG"] = RegEx.new()
	regexs["AIR_SPEED"] = RegEx.new()
	regexs["AIR_DRAG"] = RegEx.new()
	regexs["JUMP_VELOCITY"] = RegEx.new()
	regexs["JUMP_FORWARD_BOOST"] = RegEx.new()
	regexs["WALL_JUMP_VELOCITY"] = RegEx.new()
	regexs["GRAVITY"] = RegEx.new()
	regexs["WALL_GRAVITY"] = RegEx.new()
	regexs["WALL_GRAVITY_MULT"] = RegEx.new()
	regexs["MOUSE_SENSITIVITY"] = RegEx.new()
	regexs["AUTO_JUMP"] = RegEx.new()
	regexs["CEIL_STICKY"] = RegEx.new()
	regexs["WALL_STICKY"] = RegEx.new()
	regexs["reset"] = RegEx.new()
	regexs["jump"] = RegEx.new()
	
	regexs["SPEED"].compile("(^(SPEED)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["FLOOR_DRAG"].compile("(^(FLOOR_DRAG)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["AIR_SPEED"].compile("(^(AIR_SPEED)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["AIR_DRAG"].compile("(^(AIR_DRAG)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["JUMP_VELOCITY"].compile("(^(JUMP_VELOCITY)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["JUMP_FORWARD_BOOST"].compile("(^(JUMP_FORWARD_BOOST)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["WALL_JUMP_VELOCITY"].compile("(^(WALL_JUMP_VELOCITY)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["GRAVITY"].compile("(^(GRAVITY)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["WALL_GRAVITY"].compile("(^(WALL_GRAVITY)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["WALL_GRAVITY_MULT"].compile("(^(WALL_GRAVITY_MULT)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["MOUSE_SENSITIVITY"].compile("(^(MOUSE_SENSITIVITY)( *)?(=)?( *)?((-)?(\\d*)?(\\.)?(\\d*)?)$)")
	regexs["AUTO_JUMP"].compile("(^(AUTO_JUMP)( *)?(=)?( *)?((true)|(false))$)")
	regexs["CEIL_STICKY"].compile("(^(CEIL_STICKY)( *)?(=)?( *)?((true)|(false))$)")
	regexs["WALL_STICKY"].compile("(^(WALL_STICKY)( *)?(=)?( *)?((true)|(false))$)")
	regexs["reset"].compile("(^(reset))")
	regexs["jump"].compile("(^(jump))")
	
	for item in regexs:
		inputList.add_item(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isInputFocused:
		if Input.is_action_just_pressed("ui_down") and previousIndex < previous.item_count:
			previousIndex += 1
			if previousIndex == previous.item_count:
				input.clear()
			else:
				input.text = previous.get_item_text(previousIndex)
		elif Input.is_action_just_pressed("ui_up"):
			if previousIndex > 0:
				previousIndex -= 1
				input.text = previous.get_item_text(previousIndex)
	if Input.is_action_just_pressed("consoleToggle"):
		if visible:
			input.delete_text(input.caret_column-1,input.caret_column)
			input.text = input.text.trim_suffix("`")
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			input.release_focus()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			input.grab_focus()
			input.caret_column = input.text.length()
		visible = !visible
		

func commandSubmitted(command:String):
	var player = get_tree().get_nodes_in_group("player")[0]
	if !command.trim_prefix(" ").trim_suffix(" ").is_empty() and player:
		var com = command.split(' ')
		if com[0].to_lower() == "jump":
			player.jump()
		elif regexs["SPEED"].search(command) is RegExMatch:
			player.SPEED = regexs["float"].search(command).get_string().to_float()
			print(regexs["float"].search(command).get_string())
		elif regexs["FLOOR_DRAG"].search(command) is RegExMatch:
			player.FLOOR_DRAG = regexs["float"].search(command).get_string().to_float()
		elif regexs["AIR_SPEED"].search(command) is RegExMatch:
			player.AIR_SPEED = regexs["float"].search(command).get_string().to_float()
		elif regexs["AIR_DRAG"].search(command) is RegExMatch:
			player.AIR_DRAG = regexs["float"].search(command).get_string().to_float()
		elif regexs["JUMP_VELOCITY"].search(command) is RegExMatch:
			player.JUMP_VELOCITY = regexs["float"].search(command).get_string().to_float()
		elif regexs["JUMP_FORWARD_BOOST"].search(command) is RegExMatch:
			player.JUMP_FORWARD_BOOST = regexs["float"].search(command).get_string().to_float()
		elif regexs["WALL_JUMP_VELOCITY"].search(command) is RegExMatch:
			player.WALL_JUMP_VELOCITY = regexs["float"].search(command).get_string().to_float()
		elif regexs["GRAVITY"].search(command) is RegExMatch:
			player.GRAVITY = regexs["float"].search(command).get_string().to_float()
		elif regexs["WALL_GRAVITY"].search(command) is RegExMatch:
			player.WALL_GRAVITY = regexs["float"].search(command).get_string().to_float()
		elif regexs["WALL_GRAVITY_MULT"].search(command) is RegExMatch:
			player.WALL_GRAVITY_MULT = regexs["float"].search(command).get_string().to_float()
		elif regexs["MOUSE_SENSITIVITY"].search(command) is RegExMatch:
			player.MOUSE_SENSITIVITY = regexs["float"].search(command).get_string().to_float()
		elif regexs["AUTO_JUMP"].search(command) is RegExMatch:
			if regexs["bool"].search(command).get_string() == "true":
				player.AUTO_JUMP = true
			else:
				player.AUTO_JUMP = false
		elif regexs["CEIL_STICKY"].search(command) is RegExMatch:
			if regexs["bool"].search(command).get_string() == "true":
				player.CEIL_STICKY = true
			else:
				player.CEIL_STICKY = false
		elif regexs["WALL_STICKY"].search(command) is RegExMatch:
			if regexs["bool"].search(command).get_string() == "true":
				player.WALL_STICKY = true
			else:
				player.WALL_STICKY = false
		elif command == "reset":
			if get_tree().get_nodes_in_group("playerSpawn").size() > 0:
				player.position = get_tree().get_nodes_in_group("playerSpawn")[0].position
			else:
				player.position = Vector3(0,5,-1)
			player.velocity = Vector3()
		
		
		previous.add_item(command)
		previousIndex = previous.item_count
	input.clear()

#regexs["SPEED"]
#regexs["MAX_GROUND_SPEED"]
#regexs["AIR_SPEED"]
#regexs["MAX_AIR_SPEED"]
#regexs["JUMP_VELOCITY"]
#regexs["JUMP_FORWARD_BOOST"]
#regexs["WALL_JUMP_VELOCITY"]
#regexs["GRAVITY"]
#regexs["WALL_GRAVITY"]
#regexs["WALL_GRAVITY_MULT"]
#regexs["MOUSE_SENSITIVITY"]

func inputFocused():
	isInputFocused = true
func inputUnFocused():
	isInputFocused = false
