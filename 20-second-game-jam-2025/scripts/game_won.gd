extends Control

@onready var score = $VBoxContainer1/Score:
	set(value):
		score.text = "SCORE: " + str(value)
		
@onready var high_score = $VBoxContainer1/Highscore:
	set(value):
		high_score.text = "HIGH SCORE: " + str(value)

@onready var retryButton = $VBoxContainer2/Retry
@onready var quitButton = $VBoxContainer2/Quit

func _show_screen():
	$Yippee.play()
	visible = true
	retryButton.grab_focus()

func _on_retry_pressed() -> void:
	$ButtonPress.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_game.tscn")

func _on_quit_pressed() -> void:
	$ButtonPress.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_retry_focus_exited() -> void:
	$ButtonSelect.play()

func _on_quit_focus_exited() -> void:
	$ButtonSelect.play()
