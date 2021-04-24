extends Control


var drill_temperature = 0
var depth = 0
var drill_mult = 1
var drill_bonus = 0
var drilled_depth = 0.0

const MAX_DEPTH = 6_378_000_000

onready var depth_node = $HBoxContainer/Depth
onready var temperature_node = $HBoxContainer/Temperature

func _ready():
	depth_node.value = 0
	depth_node.max_value = MAX_DEPTH
	temperature_node.value = 0
	depth_node.set_progress(0.0, "mm")

	temperature_node.set_progress(0.0, "°C")

func _process(delta):
	self.drilled_depth += (delta * drill_mult + drill_bonus)
	if self.drilled_depth >= 1:
		self.drilled_depth -= 1
		temperature_node.increase_progress(1)
		depth_node.increase_progress(1)
	

func _manual_dig():
	depth_node.increase_progress(1)


func _cooldown():
	temperature_node.increase_progress(-1)
