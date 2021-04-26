extends Control


onready var label = $VBoxContainer/Label
onready var playButton = $VBoxContainer/play
onready var helpButton = $VBoxContainer/help
onready var music_node =$music

func _ready():
	playButton.grab_focus()


func _on_play_pressed():
	get_tree().change_scene("res://scenes/game.tscn")


func _on_help_pressed():
	$AcceptDialog.popup_centered()


func _on_quit_pressed():
	get_tree().quit(0)
