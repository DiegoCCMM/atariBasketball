extends Node

class_name MovementComponent

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func move(node, delta):
	# Add the gravity.
	if not node.is_on_floor():
		node.velocity.y += gravity * delta
		node.velocity.x = move_toward(node.velocity.x, 0, SPEED)
		node.move_and_slide()
		return

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and node.is_on_floor():
		node.velocity.y = JUMP_VELOCITY
		node.velocity.x = move_toward(node.velocity.x, 0, SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		node.velocity.x = direction * SPEED
	else:
		node.velocity.x = move_toward(node.velocity.x, 0, SPEED)

	node.move_and_slide()
	return direction
