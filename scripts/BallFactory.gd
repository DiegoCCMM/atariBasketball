extends Node

class_name BallFactory

@export var ball_scene: PackedScene = preload("res://scenes/ball.tscn")

func ball_factory(player):
	# Spawn the ball
	var ball_instance = ball_scene.instantiate()
	ball_instance.global_position = player.global_position  # Set the ball's position to the player's position

	# Debugging: Print ball position and check instance
	print("Ball instantiated at position: ", ball_instance.global_position)
	print("Ball instance: ", ball_instance)
	return ball_instance
