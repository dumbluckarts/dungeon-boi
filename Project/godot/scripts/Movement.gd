extends Node2D

export var MOVE_SPEED = 1000
export var DASH_SPEED = 100
export var SPRINT_SPEED = 2000

var velocity = Vector2.ZERO

func move(body: KinematicBody2D, input: Vector2, delta: float) -> Vector2:
	
	# Get speed
	var speed = input
	if Input.is_action_pressed("player1_action2"):
		speed *= SPRINT_SPEED
	else:
		speed *= MOVE_SPEED
	speed *= delta
		
	velocity = body.move_and_slide(speed, Vector2.UP)
	return velocity
