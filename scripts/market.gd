extends PopupDialog

onready var tabs = $TabContainer


func _ready():
	tabs.set_tab_disabled(3, true)
	tabs.set_tab_disabled(4, true)


func _on_Close_pressed():
	self.hide()


func drill_bought():
	tabs.set_tab_disabled(3, false)
	tabs.set_tab_disabled(4, false)
