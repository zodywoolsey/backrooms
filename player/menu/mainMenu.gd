extends Control

var main = preload("res://procedural/backrooms/main.tscn")
@onready var label = $HBoxContainer/Panel/VBoxContainer/Label
@onready var line_edit = $LineEdit

@onready var button :Button = $HBoxContainer/Panel/VBoxContainer/Button
@onready var loading_bar = $HBoxContainer/Panel/VBoxContainer/Label/loadingBar

func _ready():
	button.grab_focus()
	button.pressed.connect(func():
		Globals.seed = line_edit.text
		get_tree().get_first_node_in_group("world").add_child(main.instantiate())
		label.show()
		button.hide()
		)
	line_edit.gui_input.connect(func(e:InputEvent):
		if e.is_action("forward") or e.is_action("ui_up") or e.is_action("ui_focus_prev"):
			button.grab_focus()
		)
	line_edit.focus_entered.connect(func():
		Steam.showFloatingGamepadTextInput(Steam.FLOATING_GAMEPAD_TEXT_INPUT_MODE_SINGLE_LINE,line_edit.global_position.x,line_edit.global_position.y,0,0)
		)

func _process(delta):
	loading_bar.value = Globals.loadingProgress

