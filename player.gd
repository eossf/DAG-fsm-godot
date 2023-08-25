extends CharacterBody2D
class_name Player

@export_range(0.0, 0.1) var acceleration_factor : float = 0.1
var speed:float = 0.0
var max_speed:float = 800.0
var rotated = false
var moved = false
var rotation_direction:int = 0
var last_rotation_direction:int = 1
var direction := Vector2.ZERO
var last_direction := Vector2.ZERO

func get_input():
	rotation_direction = Input.get_axis("move_left", "move_right")
	velocity = transform.x * speed
	if rotation_direction != 0 and last_rotation_direction != rotation_direction:
		last_rotation_direction = rotation_direction
		rotated = true

	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction != Vector2.ZERO:
		last_direction = direction
		moved = true

func _physics_process(delta):
	get_input()
	if rotated:
		rotation += last_rotation_direction * deg_to_rad(180.0)
		rotated = false
	
	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, acceleration_factor)
	else:
		speed = lerp(speed, max_speed, acceleration_factor)
	
	# movement keys direction
	velocity = last_direction * speed
	move_and_slide()
