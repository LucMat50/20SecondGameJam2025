extends Node2D

@onready var bullets = $Bullets
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload("res://scenes/asteroid.tscn")

func _ready():
	player.connect("bullet_shot", _on_player_bullet_shot)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)
	
func _on_player_bullet_shot(bullet):
	bullets.add_child(bullet)

func _on_asteroid_exploded(pos, size):
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
