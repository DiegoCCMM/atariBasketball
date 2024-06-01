extends Node

class_name ShootingComponent

signal score

func time_of_animation(animated_sprite, anim):
	var relative_duration = animated_sprite.sprite_frames.get_frame_duration(anim, 1.0)
	var animation_fps = animated_sprite.sprite_frames.get_frame_count(anim)
	var playing_speed = animated_sprite.get_playing_speed()
	return(relative_duration / (animation_fps * abs(playing_speed)))

func shoot(player, factory, standing_sprite_animation, shooting_sprite_animation):
	player.animated_sprite.play(shooting_sprite_animation)

	var ball_instance = factory.ball_factory(player)
	
	var direction = calculate_direction_using_mouse_position(player)

	# Add the ball to the main scene and call the shoot method
	player.get_parent().add_child(ball_instance)
	ball_instance.shoot(direction)
	
	ball_instance.score.connect(
		func reemit():
			print("shooting component emits score")
			emit_signal("score")
	)
	
	# Use a Timer to switch back to standing animation after the shooting animation ends
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = time_of_animation(player.animated_sprite, shooting_sprite_animation)
	timer.one_shot = true
	timer.connect("timeout", 
		Callable(self, "_on_shooting_animation_done").bind(player, standing_sprite_animation)
	)
	timer.start()

func calculate_direction_using_mouse_position(player):
	var mouse_position = player.get_global_mouse_position()
	var direction = (mouse_position - player.global_position).normalized()
	return direction

func _on_shooting_animation_done(player, standing_sprite_animation):
	player.animated_sprite.play(standing_sprite_animation)
