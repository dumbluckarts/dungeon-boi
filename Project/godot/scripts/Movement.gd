extends Node2D

export var MOVE_SPEED = 1000

var velocity = Vector2.ZERO

func move(body: KinematicBody2D, input: Vector2, delta: float, scalar: float = 1.0) -> Vector2:
	
	# Get speed
	var speed = input
	
	speed *= MOVE_SPEED
	speed *= delta
	speed *= scalar
		
	velocity = body.move_and_slide(speed, Vector2.UP)
	return velocity
