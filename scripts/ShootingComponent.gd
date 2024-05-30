extends Node

class_name ShootingComponent

signal score

func time_of_animation(animated_sprite, anim):
	var relative_duration = animated_sprite.sprite_frames.get_frame_duration(anim, 1.0)
	var animation_fps = animated_sprite.sprite_frames.get_frame_count(anim)
	var playing_speed = animated_sprite.get_playing_speed()
	return(relative_duration / (animation_fps * abs(playing_speed)))

func shoot(body, spawnable, standing_sprite_animation, shooting_sprite_animation):
	# Play the shooting animation
	body.animated_sprite.play(shooting_sprite_animation)

	# Spawn the ball
	var ball_instance = spawnable.instantiate()
	ball_instance.global_position = body.global_position  # Set the ball's position to the player's position

	# Debugging: Print ball position and check instance
	print("Ball instantiated at position: ", ball_instance.global_position)
	print("Ball instance: ", ball_instance)

	# Calculate the direction to shoot the ball
	var mouse_position = body.get_global_mouse_position()
	var direction = (mouse_position - body.global_position).normalized()

	# Add the ball to the scene and call the shoot method
	body.get_parent().add_child(ball_instance)
	ball_instance.shoot(direction)
	ball_instance.score.connect(
		func reemit():
			print("shooting component emits score")
			emit_signal("score")
	)
	# Use a Timer to switch back to standing animation after the shooting animation ends
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time_of_animation(body.animated_sprite, shooting_sprite_animation)
	timer.one_shot = true
	timer.connect("timeout", 
		Callable(self, "_on_shooting_animation_done").bind(body, standing_sprite_animation)
	)
	timer.start()

func _on_shooting_animation_done(body, standing_sprite_animation):
	body.animated_sprite.play(standing_sprite_animation)
