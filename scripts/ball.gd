extends RigidBody2D

var speed = 400
signal score

func _ready():
	pass

func shoot(direction):
	linear_velocity = direction * speed

func handle_score(body):
	if body.name == name:
		print("pelota emite score")
		emit_signal("score")


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
