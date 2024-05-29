extends Node

class_name MovementComponent

@export var speed: float = 200

func get_velocity() -> Vector2:
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	return velocity.normalized() * speed

func move(entity: Node2D, delta: float):
	var velocity = get_velocity()
	entity.position += velocity * delta
