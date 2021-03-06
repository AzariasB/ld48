extends TextureProgress

onready var label_node = $Label
var unit = ""

func set_progress(progress, unit: String = ""):
	if unit:
		self.unit = unit
	else:
		unit = self.unit
	var text = str(progress) + " " + unit
	label_node.text = text
	self.value = progress

func increase_progress(progress):
	self.set_progress(max(self.min_value, min(self.value + progress, self.max_value)) , self.unit)	
	if self.value >= self.max_value:
		global.emit_signal("max_temperature_reached")
