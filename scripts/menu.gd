extends Control


onready var label = $VBoxContainer/Label
onready var playButton = $VBoxContainer/play
onready var helpButton = $VBoxContainer/help
onready var music_node =$music

func _ready():
	playButton.grab_focus()


func _on_play_pressed():
	$Click.play()
	Transition.fade_to("res://scenes/game.tscn")


func _on_help_pressed():
	$Click.play()
	$AcceptDialog.popup_centered()
	$Tween.interpolate_property($AcceptDialog,"modulate:a",0, 1, 0.2,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)
	$Tween.start()


func _on_quit_pressed():
	get_tree().quit(0)


func _on_help_hide():
	$Click.play()
	$Tween.interpolate_property($AcceptDialog,"modulate:a",1, 0, 0.2,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	$AcceptDialog.hide()
