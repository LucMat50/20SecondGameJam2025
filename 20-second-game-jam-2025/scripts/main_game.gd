extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var game_over = $"UI/Game Over"
@onready var canvasMod = $CanvasModulate/AnimationPlayer

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var player_scene = preload("res://scenes/player.tscn")

var lives = 3:
	set(value):
		lives = value
		hud.init_lives(lives)
		
var score := 0:
	set(value):
		score = value
		hud.score = score

var timer := 20:
	set(value):
		timer = value
		hud.timer = timer

signal stop_timer

func _ready():
	score = 0
	lives = 3
	game_over.hide()
	canvasMod.play("RESET")
	player.connect("bullet_shot", _on_player_bullet_shot)
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
	
func _on_player_bullet_shot(bullet):
	bullets.add_child(bullet)

func _on_asteroid_exploded(pos, size, points):
	score += points
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				_spawn_more(pos, Asteroid.AsteroidSize.MEDIUM)
				
			Asteroid.AsteroidSize.MEDIUM:
				_spawn_more(pos, Asteroid.AsteroidSize.SMALL)
				
			Asteroid.AsteroidSize.SMALL:
				pass

func _spawn_more(pos, size):
	var another = asteroid_scene.instantiate()
	another.global_position = pos
	another.size = size
	another.connect("exploded", _on_asteroid_exploded)
	asteroids.add_child(another)

func _on_player_died():
	lives -= 1
	print(lives)
	if lives <= 0:
		emit_signal("stop_timer")
		canvasMod.play("fade_out")
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		game_over._show_screen()
