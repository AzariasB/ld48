extends Particles2D




func _ready():
	self.emitting = true
	self.position = get_global_mouse_position()
	yield(get_tree().create_timer(self.lifetime), "timeout")
	get_parent().remove_child(self)

