extends KinematicBody2D

export var SPEED = 100

var speed_multiplier = 1.0
var velocity = Vector2.ZERO
var direction = "down"

func move():
	move_and_slide((velocity * SPEED) * speed_multiplier, Vector2.UP)

func up():
	direction = "up"
	velocity = Vector2.UP

func down():
	direction = "down"
	velocity = Vector2.DOWN
	
func left():
	direction = "left"
	velocity = Vector2.LEFT
	
func right():
	direction = "right"
	velocity = Vector2.RIGHT
	
func stop():
	velocity = Vector2.ZERO
