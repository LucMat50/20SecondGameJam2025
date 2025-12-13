extends Control

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		$ButtonPress.play()
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
