extends Node2D

const SAVEFILE = "user://savefile.save"

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD
@onready var game_over = $"UI/Game Over"
@onready var game_won = $UI/Winner
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
		game_won.score = score

var high_score := 0:
	set(value):
		high_score = value
		game_won.high_score = high_score

var current_score = 0
var player_won = false

signal stop_timer

func _ready():
	_load_score()
	score = 0
	lives = 3
	game_over.hide()
	canvasMod.play("RESET")
	player.connect("bullet_shot", _on_player_bullet_shot)
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
	
func _on_player_bullet_shot(bullet):
	$LaserSound.play()
	bullets.add_child(bullet)

func _on_asteroid_exploded(pos, size, points):
	$AsteroidSound.play()
	score += points
	for i in randi_range(1, 3):
		match size:
			Asteroid.AsteroidSize.LARGE:
				_spawn_more(pos, Asteroid.AsteroidSize.MEDIUM)
				
			Asteroid.AsteroidSize.MEDIUM:
				_spawn_more(pos, Asteroid.AsteroidSize.SMALL)
	
	for i in range(1, 2):
		match size:			
			Asteroid.AsteroidSize.SMALL:
				_spawn_large()

func _spawn_more(pos, size):
	var another = asteroid_scene.instantiate()
	another.global_position = pos
	another.size = size
	another.connect("exploded", _on_asteroid_exploded)
	asteroids.add_child(another)

func _spawn_large():
	var large = asteroid_scene.instantiate()
	large.global_position = Vector2(randi_range(0, 640), randi_range(640, 620))
	large.size = Asteroid.AsteroidSize.LARGE
	large.connect("exploded", _on_asteroid_exploded)
	asteroids.add_child(large)

func _on_player_died():
	$LostLifeSound.play()
	lives -= 1
	print(lives)
	if lives <= 0:
		emit_signal("stop_timer")
		canvasMod.play("fade_out")
		player.set_process_mode(Node.PROCESS_MODE_DISABLED)

func _on_hud_player_won() -> void:
	player_won = true

func _save_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE_READ)
	if file:
		file.store_32(high_score)

func _load_score() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	if FileAccess.file_exists(SAVEFILE):
		high_score = file.get_32()

func _update_high_score() -> void:
	if score > high_score:
		high_score = score
		_save_score()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		if lives <= 0:
			game_over._show_screen()
			print(high_score)
		elif player_won:
			_update_high_score()
			game_won._show_screen()
			print(high_score)
