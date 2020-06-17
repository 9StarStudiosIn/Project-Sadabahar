extends KinematicBody

var direction: Vector3
var velocity: Vector3
export var speed:int = 20
var gravity = -1

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	direction.x = 0
	direction.z = 0
	
	if Input.is_action_pressed("walk_forward"):
		direction -= transform.basis.z
	
	if Input.is_action_pressed("walk_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("walk_left") and Input.is_action_pressed("rotate_player"):
		rotation_degrees.y += 2.5
	elif Input.is_action_pressed("walk_left"):
		direction -= transform.basis.x
	
	if Input.is_action_pressed("walk_right") and Input.is_action_pressed("rotate_player"):
		rotation_degrees.y -= 2.5
	elif Input.is_action_pressed("walk_right"):
		direction += transform.basis.x

func process_movement(delta):
	direction = direction.normalized()
	if is_on_floor():
		velocity = direction * speed
	else:
		velocity.y += gravity
	move_and_slide(velocity, Vector3(0,1,0), 4)
