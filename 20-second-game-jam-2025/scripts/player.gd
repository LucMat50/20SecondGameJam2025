extends CharacterBody2D

# NORMAL VARIABLES
var shoot_coolDown = false
var angy = false

# EXPORT VARIABLES
@export var speed = 400
@export var rotation_speed = 100
@export var acceleration = 5

# ONREADY VARIABLES
@onready var shooter = $Shooter
@onready var ship = $Sprite2D

# SCENES
var bullet_scene = preload("res://scenes/bullet.tscn")

# SIGNALS
signal bullet_shot(bullet)

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		angy = true
		if !shoot_coolDown:
			shoot_coolDown = true
			shoot_bullet()
			await get_tree().create_timer(0.1).timeout
			shoot_coolDown = false
	else:
		angy = false
	
	angy_face()

func _physics_process(delta):
	var input_vector = Vector2(0, Input.get_axis("move_up", "move_down"))
	
	velocity += input_vector.rotated(rotation) * acceleration
	velocity = velocity.limit_length(speed)
	
	if Input.is_action_pressed("move_right"):
		rotate(deg_to_rad(rotation_speed * delta))
	elif Input.is_action_pressed("move_left"):
		rotate(deg_to_rad(-rotation_speed * delta))
	
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 3)
	
	move_and_slide()
	
	
	var screen_size = get_viewport_rect().size
	if global_position.y < -200:
		global_position.y = screen_size.y + 200
	elif global_position.y > screen_size.y + 200:
		global_position.y = -200
	
	if global_position.x < -200:
		global_position.x = screen_size.x + 200
	elif global_position.x > screen_size.x + 200:
		global_position.x = -200

func shoot_bullet():
	var heckYe = bullet_scene.instantiate()
	heckYe.global_position = shooter.global_position
	heckYe.rotation = rotation
	emit_signal("bullet_shot", heckYe)

func angy_face():
	if angy:
		ship.frame = 1
	else:
		ship.frame = 0
