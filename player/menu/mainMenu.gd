extends Control

var main = preload("res://procedural/backrooms/main.tscn")
@onready var label = $HBoxContainer/Panel/VBoxContainer/Label
@onready var line_edit = $LineEdit

@onready var button = $HBoxContainer/Panel/VBoxContainer/Button

func _ready():
	button.pressed.connect(func():
		Globals.seed = line_edit.text
		get_tree().get_first_node_in_group("world").add_child(main.instantiate())
		label.show()
		button.hide()
		)
