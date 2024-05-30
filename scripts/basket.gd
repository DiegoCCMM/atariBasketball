extends Node2D

@onready var canasta: Area2D = $Canasta

func _ready():
	pass

func _on_canasta_body_entered(body):
	get_tree().call_group("scorable", "handle_score", body)
