extends Control

@onready var retryButton = $VBoxContainer/Retry
@onready var quitButton = $VBoxContainer/Quit

func _ready():
	retryButton.grab_focus()


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	pass
