extends TextureProgress

onready var label_node = $Label
var unit = ""


func set_progress(progress, unit: String):
	var text = str(progress) + " " + unit
	self.unit = unit
	label_node.text = text
	self.value = progress

func increase_progress(progress):
	self.set_progress(max(self.value + progress, self.min_value) , self.unit)
