extends TextureRect

export(int) var max_value = 0

var value = 0 setget _set_value

onready var label_node = $Level/Label
onready var group_node = $Level

func _ready():
	pass # Replace with function body.

func _display_value(value):
	if value < 100:
		return str(value) + " mm"
	
	if value < 1000:
		return str(int(value / 10)) + " cm"
	
	if value < 10_00:
		return str(int(value / 100)) + " dm"
	
	if value < 100_000:
		return str(int(value / 1_000)) + " m"
	
	if value < 10_000_000:
		return str(int(value / 100_000) / 10.0) + " km"
	
	return str(int(value / 1_000_000)) + " km"

func _set_value(nw_value):
	var nw_y = self.rect_size.y * (nw_value / float(max_value))
	var nw_pos = Vector2(group_node.rect_position.x, nw_y)
	group_node.set_position(nw_pos)
	label_node.text = _display_value(nw_value)
	value = min(nw_value, max_value)
	if value >= max_value:
		global.emit_signal("end_reached")
