extends VBoxContainer

export(int) var max_value = 0

var value = 0 setget _set_value

onready var value_node = $DepthValue

func _ready():
	$DepthMax.text = _display_value(max_value)


func _display_value(value):
	if value < 1000:
		return str(int(value)) + " cm"
	
	if value < 10_00:
		return str(int(value) / 10.0).pad_decimals(1) + " dm"
	
	if value < 100_000:
		return str(int(value / 1_0) / 10.0).pad_decimals(1) + " m"
	
	if value < 10_000_000:
		return str(int(value / 10_000) / 10.0).pad_decimals(1) + " km"
	
	return str(int(value / 1_00_000)) + " km"

func _set_value(nw_value):
	value = nw_value
	value_node.text = _display_value(nw_value)
	if value >= max_value:
		global.emit_signal("end_reached")
