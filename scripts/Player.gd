extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement_component: MovementComponent = $MovementComponent
@onready var shooting_component: ShootingComponent = $ShootingComponent

var BallScene = preload("res://scenes/ball.tscn")
signal score

func _ready():
	# Ensure the mouse is visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	animated_sprite.play("standing")
	$ShootingComponent.score.connect(
		func reemit():
			print("player emits score")
			emit_signal("score")
	)

func _process(delta):
	var direction = movement_component.move(self, delta)
	turn_sprite_around_based_on_direction(direction)
	
	# Example input for shooting, you can change this to your actual input logic
	if Input.is_action_just_pressed("shoot"):
		shooting_component.shoot(self, BallScene, "standing", "shooting")

func turn_sprite_around_based_on_direction(direction):
	if direction:
		self.animated_sprite.scale.x = direction
