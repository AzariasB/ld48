extends Control

# This script demonstrates how to alter StyleBoxes at runtime.
# Custom theme item properties aren't considered Object properties per se.
# This means that you should use `add_stylebox_override("normal", ...)`
# instead of `set("custom_styles/normal", ...)`.

onready var label = $VBoxContainer/Label
onready var button = $VBoxContainer/Button
onready var button2 = $VBoxContainer/Button2
onready var reset_all_button = $VBoxContainer/ResetAllButton


func _ready():

	button.grab_focus()


func _on_button_pressed():
	var new_stylebox_normal = button.get_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(1, 1, 0)
	var new_stylebox_hover = button.get_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(1, 1, 0)
	var new_stylebox_pressed = button.get_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(1, 1, 0)

	button.add_stylebox_override("normal", new_stylebox_normal)
	button.add_stylebox_override("hover", new_stylebox_hover)
	button.add_stylebox_override("pressed", new_stylebox_pressed)

	label.add_color_override("font_color", Color(1, 1, 0.5))


func _on_button2_pressed():
	var new_stylebox_normal = button2.get_stylebox("normal").duplicate()
	new_stylebox_normal.border_color = Color(0, 1, 0.5)
	var new_stylebox_hover = button2.get_stylebox("hover").duplicate()
	new_stylebox_hover.border_color = Color(0, 1, 0.5)
	var new_stylebox_pressed = button2.get_stylebox("pressed").duplicate()
	new_stylebox_pressed.border_color = Color(0, 1, 0.5)

	button2.add_stylebox_override("normal", new_stylebox_normal)
	button2.add_stylebox_override("hover", new_stylebox_hover)
	button2.add_stylebox_override("pressed", new_stylebox_pressed)

	label.add_color_override("font_color", Color(0.5, 1, 0.75))


func _on_reset_all_button_pressed():
	button.add_stylebox_override("normal", null)
	button.add_stylebox_override("hover", null)
	button.add_stylebox_override("pressed", null)

	button2.add_stylebox_override("normal", null)
	button2.add_stylebox_override("hover", null)
	button2.add_stylebox_override("pressed", null)

	var default_label_color = Label.new().get_color("font_color")
	label.add_color_override("font_color", default_label_color)
