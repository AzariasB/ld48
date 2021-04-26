extends PopupDialog

onready var tabs = $TabContainer


func _ready():
	tabs.set_tab_disabled(3, true)
	tabs.set_tab_disabled(4, true)


func _on_Close_pressed():
	$Tween.interpolate_property(self, "modulate:a", 1, 0, 0.2, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	self.hide()


func show():
	self.popup_centered()
	$Tween.interpolate_property(self, "modulate:a", 0, 1, 0.2, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)
	$Tween.start()

func drill_bought():
	tabs.set_tab_disabled(3, false)
	tabs.set_tab_disabled(4, false)
