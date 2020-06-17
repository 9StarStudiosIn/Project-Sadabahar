extends KinematicBody

var direction: Vector3
var velocity: Vector3
export var speed:int = 20
var i = 0

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	direction.x = 0
	direction.z = 0
	
	if Input.is_action_pressed("walk_forward"):
		direction.z -= 1
	
	if Input.is_action_pressed("walk_backward"):
		direction.z += 1
	
	if Input.is_action_pressed("walk_left") and Input.is_action_pressed("rotate_player"):
		rotation_degrees.y += 2.5
	elif Input.is_action_pressed("walk_left"):
		direction.x -= 1
	
	if Input.is_action_pressed("walk_right") and Input.is_action_pressed("rotate_player"):
		rotation_degrees.y -= 2.5
	elif Input.is_action_pressed("walk_right"):
		direction.x += 1

func process_movement(delta):
	velocity = direction * speed
	move_and_slide(velocity, Vector3(0,1,0), 4)
