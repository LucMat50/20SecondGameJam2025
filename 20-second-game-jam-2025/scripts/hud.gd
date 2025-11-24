extends Control

@onready var score = $VBoxContainer/Score:
	set(value):
		score.text = "SCORE: " + str(value)
