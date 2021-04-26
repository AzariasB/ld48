extends HBoxContainer

export(int) var max_value = 0
export(Array, Texture) var textures = []

var value = 0 setget _set_value

var targets = []
var current_target = 0

onready var label_node = $overall/Control/Label
onready var sub_progress = $SubLayer/dug

func _ready():
	for i in textures.size():
		targets.push_front(round(max_value / exp(i*2)))
	
	print(targets)
	current_target = 0

func _display_value(value):
	if value < 100:
		return str(value) + " mm"
	
	if value < 1000:
		return str(int(value) / 10.0) + " cm"
	
	if value < 10_00:
		return str(int(value / 10) / 10.0) + " dm"
	
	if value < 100_000:
		return str(int(value / 1_00) / 10.0) + " m"
	
	if value < 10_000_000:
		return str(int(value / 100_000) / 10.0) + " km"
	
	return str(int(value / 1_000_000)) + " km"

func _next_target():
	current_target += 1
	if current_target < textures.size():
		$SubLayer.texture = textures[current_target]
		sub_progress.rect_size.y = 1

func _update_local_progress(nw_value):
	var current_value = targets[current_target]
	if nw_value > current_value:
		_next_target()
	elif nw_value > 0:
		var prev_value = 0 if current_target == 0 else targets[current_target - 1]
		var remains = (current_value - nw_value) / float(current_value - prev_value)
		print(remains)
		sub_progress.rect_size.y = self.rect_size.y * (1 - remains)

func _set_value(nw_value):
	var nw_y = self.rect_size.y * (nw_value / float(max_value))
	var nw_pos = Vector2(label_node.get_parent().rect_position.x, nw_y)
	label_node.get_parent().set_position(nw_pos)
	label_node.text = _display_value(nw_value)
	value = min(nw_value, max_value)
	_update_local_progress(nw_value)
	if value >= max_value:
		global.emit_signal("end_reached")
