extends CharacterBody2D
class_name AnimatableCharacterBody2D

signal go_left
signal go_right

@export_range(0.0, 0.07) var acceleration_factor : float = 0.07
var speed:float = 0.0
var max_speed:float = 1000.0
var min_speed:float = 50.0
var rotated:float = 0.0
var direction := Vector2.RIGHT
var last_direction := Vector2.RIGHT

func _turn(r:float):
	rotation = r

func _get_input():
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# capture a changing keys pressed input, but not the "idle" (keys released)
	if  direction != Vector2.ZERO and last_direction != direction:
		# capture direction right or left
		if direction.x == 1:
			rotated = 0.0
			emit_signal("go_right")
		elif direction.x == -1:
			rotated = -PI
			emit_signal("go_left")
		last_direction = direction

func _physics_process(delta):
	# movement keys direction
	_get_input()

	if direction == Vector2.ZERO:
		speed = lerp(speed, 0.0, acceleration_factor)
		if speed <= min_speed:
			speed = 0.0
	else:
		_turn(rotated)
		speed = lerp(speed, max_speed, acceleration_factor)
	
	velocity = last_direction * speed
	move_and_slide()

# --------------------- LISTENING SIGNALS ---------------------

func _on_root_request_turn_left():
	rotated = -PI
	_turn(rotated)

func _on_root_request_turn_right():
	rotated = 0.0
	_turn(rotated)
