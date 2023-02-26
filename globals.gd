extends Node

var player : CharacterBody3D
var world : Node3D
var environment : Environment
var pause : Control
var seed : String = "10"

var settings : Dictionary = {
	"SDFGI": {
		"enabled": false,
		"useOcclusion": true,
		"bounceFeedback": .85,
		"cascades": 4,
		"minCellSize": .2,
		"cascade0Distance": 13,
		"maxDistance": 210.0,
		"yScale": Environment.SDFGI_Y_SCALE_100_PERCENT,
		"energy": 5.0,
		"normalBias": 1.1,
		"probeBias": 1.1
	},
	"Glow": {
		"enabled": true,
		"intensity": 8.0,
		"strength": 1.1,
		"bloom": 0.8,
		"blendMode": Environment.GLOW_BLEND_MODE_SOFTLIGHT,
		"hdrThreshold": 0.0,
		"hdrScale": 2.0,
		"hdrLuminanceCap": 12.0
	},
	"Fog": {
		"enabled": true
	}
}

@export_enum("main","pause","none") var UI_STATE : int = 1

func _ready():
	find_player()

func _process(delta):
	if pause:
		if UI_STATE == 1:
			pause.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif UI_STATE == 2:
			pause.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("ui_cancel"):
		print('pause')
		if UI_STATE == 1:
			UI_STATE = 2
		elif UI_STATE == 2:
			UI_STATE = 1

func find_player():
	player = get_tree().get_first_node_in_group('player')

func is_player_found():
	print(player)

func find_environment():
	var tmp = get_tree().get_first_node_in_group("environment")
	print(tmp)
	if tmp is WorldEnvironment:
		environment = tmp.environment
		print('world')
	elif tmp is Environment:
		environment = tmp
		print('env')

func setSDFGI(newSettings:Dictionary):
	if !environment:
		find_environment()
	if newSettings.has("enabled") and newSettings["enabled"] is bool:
		settings["SDFGI"]["enabled"] = newSettings["enabled"]
	if newSettings.has("useOcclusion") and newSettings["useOcclusion"] is bool:
		settings["SDFGI"]["useOcclusion"] = newSettings["useOcclusion"]
	if newSettings.has("bounceFeedback") and newSettings["bounceFeedback"] is float:
		settings["SDFGI"]["bounceFeedback"] = newSettings["bounceFeedback"]
	if newSettings.has("cascades") and newSettings["cascades"] is int:
		settings["SDFGI"]["cascades"] = newSettings["cascades"]
	if newSettings.has("minCellSize") and newSettings["minCellSize"] is float:
		settings["SDFGI"]["minCellSize"] = newSettings["minCellSize"]
	if newSettings.has("cascade0Distance") and newSettings["cascade0Distance"] is float:
		settings["SDFGI"]["cascade0Distance"] = newSettings["cascade0Distance"]
	if newSettings.has("maxDistance") and newSettings["maxDistance"] is float:
		settings["SDFGI"]["maxDistance"] = newSettings["maxDistance"]
	if newSettings.has("yScale") and newSettings["yScale"] is int:
		settings["SDFGI"]["yScale"] = newSettings["yScale"]
	if newSettings.has("energy") and newSettings["energy"] is float:
		settings["SDFGI"]["energy"] = newSettings["energy"]
	if newSettings.has("normalBias") and newSettings["normalBias"] is float:
		settings["SDFGI"]["normalBias"] = newSettings["normalBias"]
	if newSettings.has("probeBias") and newSettings["probeBias"] is float:
		settings["SDFGI"]["probeBias"] = newSettings["probeBias"]
	
	environment.sdfgi_enabled = settings["SDFGI"]["enabled"]
	environment.sdfgi_use_occlusion = settings["SDFGI"]["useOcclusion"]
	environment.sdfgi_bounce_feedback = settings["SDFGI"]["bounceFeedback"]
	environment.sdfgi_cascades = settings["SDFGI"]["cascades"]
	environment.sdfgi_min_cell_size = settings["SDFGI"]["minCellSize"]
	environment.sdfgi_cascade0_distance = settings["SDFGI"]["cascade0Distance"]
	environment.sdfgi_max_distance = settings["SDFGI"]["maxDistance"]
	environment.sdfgi_y_scale = settings["SDFGI"]["yScale"]
	environment.sdfgi_energy = settings["SDFGI"]["energy"]
	environment.sdfgi_normal_bias = settings["SDFGI"]["normalBias"]
	environment.sdfgi_probe_bias = settings["SDFGI"]["probeBias"]

func setFog(newSettings:Dictionary):
	if !environment:
		find_environment()
	if newSettings.has("enabled") and newSettings["enabled"] is bool:
		settings["Fog"]["enabled"] = newSettings["enabled"]
	
	environment.volumetric_fog_enabled = settings["Fog"]["enabled"]
	
