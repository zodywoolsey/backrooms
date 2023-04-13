extends Control

func _process(delta):
	if Globals.UI_STATE == 1:
		visible = true
	else:
		visible = false
