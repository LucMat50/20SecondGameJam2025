class_name Asteroid extends Area2D

# NORMAL VARIABLES
var movement_vector = Vector2(-1, 0)
var speed = 50

# ENUM VARIABLES
enum AsteroidSize{LARGE, MEDIUM, SMALL}

# EXPORT VARIABLES
@export var size = AsteroidSize.LARGE

# ONREADY VARIABLES
@onready var asteroid = $Sprite2D
@onready var collision = $CollisionShape2D

# SIGNALS
signal exploded(position, size)

func _ready():
	rotation = randf_range(0, 2 * PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50, 100)
			asteroid.scale = Vector2(2, 2)
			collision.scale = Vector2(2, 2)
			
		AsteroidSize.MEDIUM:
			speed = randf_range(100, 150)
			asteroid.scale = Vector2(1, 1)
			collision.scale = Vector2(1, 1)
			
		AsteroidSize.SMALL:
			speed = randf_range(150, 200)
			asteroid.scale = Vector2(0.5, 0.5)
			collision.scale = Vector2(0.5, 0.5)

func _physics_process(delta: float) -> void:
	global_position += movement_vector.rotated(rotation) * speed * delta
	
	var radius = collision.shape.radius + 5
	var screen_size = get_viewport_rect().size
	if global_position.y + radius < 0:
		global_position.y = screen_size.y + radius
	elif global_position.y - radius > screen_size.y:
		global_position.y = -radius
	
	if global_position.x + radius < 0:
		global_position.x = screen_size.x + radius
	elif global_position.x - radius > screen_size.x:
		global_position.x = -radius

func _explode():
	emit_signal("exploded", global_position, size)
	queue_free()
