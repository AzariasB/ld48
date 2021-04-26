extends Label


func init(money_value):
	var prefix = "+" if money_value > 0 else ""
	text = prefix  + str(money_value) + " €"
	var font_color = Color.green if money_value > 0 else Color.red
	self.add_color_override("font_color", font_color)
	var anim = "GreenFadeOut" if money_value > 0 else "FadeOut"
	$AnimationPlayer.play(anim)
	$AnimationPlayer.connect("animation_finished", self, "_destroy")

func _destroy(_anim_name):
	get_parent().remove_child(self)
