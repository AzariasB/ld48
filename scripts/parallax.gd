extends ParallaxBackground


func _process(delta):
	var new_offset: Vector2 = get_scroll_offset() - Vector2(delta * 10, 0) 
	scroll_offset = new_offset
