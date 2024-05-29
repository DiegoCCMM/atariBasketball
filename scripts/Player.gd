extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_component: MovementComponent = $MovementComponent

var BallScene = preload("res://scenes/ball.tscn")
signal score

func time_of_animation(animated_sprite, anim):
	var relative_duration = animated_sprite.sprite_frames.get_frame_duration(anim, 1.0)
	var animation_fps = animated_sprite.sprite_frames.get_frame_count(anim)
	var playing_speed = animated_sprite.get_playing_speed()
	return(relative_duration / (animation_fps * abs(playing_speed)))

func _ready():
	# Ensure the mouse is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animated_sprite.play("standing")

func shoot():
	# Play the shooting animation
	animated_sprite.play("shooting")

	# Spawn the ball
	var ball_instance = BallScene.instantiate()
	ball_instance.global_position = global_position  # Set the ball's position to the player's position

	# Debugging: Print ball position and check instance
	print("Ball instantiated at position: ", ball_instance.global_position)
	print("Ball instance: ", ball_instance)

	# Calculate the direction to shoot the ball
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()

	# Add the ball to the scene and call the shoot method
	get_parent().add_child(ball_instance)
	ball_instance.shoot(direction)
	ball_instance.score.connect(
		func reemit():
			print("player emits score")
			emit_signal("score")
	)
	# Use a Timer to switch back to standing animation after the shooting animation ends
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time_of_animation(animated_sprite, "shooting")
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_shooting_animation_done"))
	timer.start()

func _on_shooting_animation_done():
	animated_sprite.play("standing")

func _process(delta):
	movement_component.move(self, delta)
	rotate_to_mouse()
	
	# Example input for shooting, you can change this to your actual input logic
	if Input.is_action_just_pressed("shoot"):
		shoot()

func rotate_to_mouse():
	# Get the global position of the player
	var player_position = global_position
	# Get the global position of the mouse pointer
	var mouse_position = get_global_mouse_position()

	# Determine if the mouse is to the left or right of the player
	if mouse_position.x < player_position.x:
		# Flip the player to face left
		scale.x = -1
	else:
		# Flip the player to face right
		scale.x = 1
