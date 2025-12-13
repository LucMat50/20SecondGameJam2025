extends Control

@onready var score = $VBoxContainer/Score:
	set(value):
		score.text = "SCORE: " + str(value)

@onready var timer = $WorldTimer
@onready var countDown = $VBoxContainer/Timer

@onready var lives = $VBoxContainer/Lives

@onready var canvasMod = $/root/main_game/CanvasModulate/AnimationPlayer
@onready var player = $/root/main_game/Player

signal player_won

var life_scene = preload("res://scenes/life.tscn")

func init_lives(amount):
	for life in lives.get_children():
		life.queue_free()

	for i in amount:
		var life = life_scene.instantiate()
		lives.add_child(life)

func _ready():
	timer.start()
	
func _time_left():
	var time_left = timer.time_left
	var second = int(time_left) % 60
	return [second]

func _process(_delta: float) -> void:
	countDown.text = "TIMER: %02d" % _time_left()

func _on_main_game_stop_timer() -> void:
	timer.paused = true

func _on_world_timer_timeout() -> void:
	player.set_process_mode(Node.PROCESS_MODE_DISABLED)
	canvasMod.play("fade_out")
	emit_signal("player_won")
