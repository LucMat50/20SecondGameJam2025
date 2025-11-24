extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var hud = $UI/HUD

var asteroid_scene = preload("res://scenes/asteroid.tscn")
var player_scene = preload("res://scenes/player.tscn")

var lives = 3
var score := 0:
	set(value):
		score = value
		hud.score = score

func _ready():
	score = 0
	lives = 3
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
		print("game over")
		pass
