extends Node

class_name MovementComponent

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func move(node, delta):
	# Add the gravity.
	if not get_parent().is_on_floor():
		get_parent().velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and get_parent().is_on_floor():
		get_parent().velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		get_parent().velocity.x = direction * SPEED
	else:
		get_parent().velocity.x = move_toward(get_parent().velocity.x, 0, SPEED)

	get_parent().move_and_slide()
