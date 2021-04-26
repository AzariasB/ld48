extends AudioStreamPlayer



func _ready():
	if not OS.is_debug_build():
		self.playing = true

