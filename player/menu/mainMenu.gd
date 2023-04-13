extends Control

var main = preload("res://procedural/backrooms/main.tscn")
@onready var label = $HBoxContainer/Panel/VBoxContainer/Label
@onready var line_edit = $LineEdit

@onready var button :Button = $HBoxContainer/Panel/VBoxContainer/Button
@onready var loading_bar = $HBoxContainer/Panel/VBoxContainer/Label/loadingBar

func _ready():
	button.pressed.connect(func():
		Globals.seed = line_edit.text
		get_tree().get_first_node_in_group("world").add_child(main.instantiate())
		label.show()
		button.hide()
		)

func _process(delta):
	loading_bar.value = Globals.loadingProgress

