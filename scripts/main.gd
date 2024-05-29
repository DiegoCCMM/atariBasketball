extends Node

@onready var basket1 = $Basket1
@onready var basket2 = $Basket2

var score = 0

func _ready():
	$Player.score.connect(_on_ball_score)

func _on_ball_score():
	score += 1
	print("Score: ", score)
	$Score.text = "Score: " + str(score)
