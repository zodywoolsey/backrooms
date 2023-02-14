extends Control
@onready var enabled_2 : CheckButton = $ScrollContainer/settings/enabled/Control2/enabled2
@onready var use_occlusion_2 : CheckButton = $"ScrollContainer/settings/use occlusion/Control/use occlusion2"
@onready var bounce_feedback_2 : Slider = $"ScrollContainer/settings/bounce feedback/Control2/bounce feedback2"
@onready var cascades_2 : Slider = $ScrollContainer/settings/cascades/Control2/cascades2
@onready var min_cell_size_2 : Slider = $"ScrollContainer/settings/min cell size/Control2/min cell size2"
@onready var cascade_0_distance_2 : Slider = $"ScrollContainer/settings/cascade 0 distance/Control2/cascade 0 distance2"
@onready var max_distance_2 : Slider = $"ScrollContainer/settings/max distance/Control2/max distance2"
@onready var y_scale_2 : Slider = $"ScrollContainer/settings/y scale/Control2/y scale2"
@onready var energy_2 : Slider = $ScrollContainer/settings/energy/Control2/energy2
@onready var normal_bias_2 : Slider = $"ScrollContainer/settings/normal bias/Control2/normal bias2"
@onready var probe_bias_2 : Slider = $"ScrollContainer/settings/probe bias/Control2/probe bias2"

func _ready():
	setValues()
	Globals.pause = self
	enabled_2.toggled.connect(func (val):
		Globals.setSDFGI({"enabled":val})
		)
	use_occlusion_2.toggled.connect(func (val):
		Globals.setSDFGI({"useOcclusion":val})
		)
	bounce_feedback_2.value_changed.connect(func (val):
		Globals.setSDFGI({"bounceFeedback":val})
		)
	cascades_2.value_changed.connect(func (val):
		Globals.setSDFGI({"cascades":val})
		)
	min_cell_size_2.value_changed.connect(func (val):
		Globals.setSDFGI({"minCellSize":val})
		)
	cascade_0_distance_2.value_changed.connect(func (val):
		Globals.setSDFGI({"cascade0Distance":val})
		)
	max_distance_2.value_changed.connect(func (val):
		Globals.setSDFGI({"maxDistance":val})
		)
	y_scale_2.value_changed.connect(func (val):
		Globals.setSDFGI({"yScale":val})
		)
	energy_2.value_changed.connect(func (val):
		Globals.setSDFGI({"energy":val})
		)
	normal_bias_2.value_changed.connect(func (val):
		Globals.setSDFGI({"normalBias":val})
		)
	probe_bias_2.value_changed.connect(func (val):
		Globals.setSDFGI({"probeBias":val})
		)

func setValues():
	var s = Globals.settings["SDFGI"]
	enabled_2.button_pressed = s["enabled"]
	use_occlusion_2.button_pressed = s["useOcclusion"]
	bounce_feedback_2.value = s["bounceFeedback"]
	cascades_2.value = s["cascades"]
	min_cell_size_2.value = s["minCellSize"]
	cascade_0_distance_2.value = s["cascade0Distance"]
	max_distance_2.value = s["maxDistance"]
	y_scale_2.value = s["yScale"]
	energy_2.value = s["energy"]
	normal_bias_2.value = s["normalBias"]
	probe_bias_2.value = s["probeBias"]
