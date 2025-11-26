extends Control

@onready var playButton = $VBoxContainer/Play

func _ready():
	playButton.grab_focus()
	
func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
