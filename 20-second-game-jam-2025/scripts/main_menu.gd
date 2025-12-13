extends Control

@onready var playButton = $VBoxContainer/Play

func _ready():
	playButton.grab_focus()
	
func _on_play_pressed() -> void:
	$ButtonPress.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_tutorial_pressed() -> void:
	$ButtonPress.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func _on_play_focus_exited() -> void:
	$ButtonSelect.play()

func _on_tutorial_focus_exited() -> void:
	$ButtonSelect.play()
