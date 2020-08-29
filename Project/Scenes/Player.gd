extends KinematicBody2D

export var VERTICAL_SPEED = 100
export var HORIZONTAL_SPEED = 100

var velocity = Vector2.ZERO
var direction = "down"
var action = "idle"

func _process(_delta):
	input()
	move()
	animate()
	
# !START Movement
func move():
	move_and_slide(velocity, Vector2.UP)
	
func input():
	if Input.is_action_pressed("player_up"):
		up()
	elif Input.is_action_pressed("player_down"):
		down()
	elif Input.is_action_pressed("player_left"):
		left()
	elif Input.is_action_pressed("player_right"):
		right()
	else:
		stop()

func up():
	direction = "up"
	action = "walk"
	velocity = Vector2(0, -VERTICAL_SPEED)
	
func down():
	direction = "down"
	action = "walk"
	velocity = Vector2(0, VERTICAL_SPEED)
	
func left():
	direction = "left"
	action = "walk"
	velocity = Vector2(-HORIZONTAL_SPEED, 0)
	
func right():
	direction = "right"
	action = "walk"
	velocity = Vector2(HORIZONTAL_SPEED, 0)
	
func stop():
	action = "idle"
	velocity = Vector2.ZERO
# !END Movement

# !START Animation
func get_animation():
	return action + "_" + direction
	
func animate():
	$AnimatedSprite.play(get_animation())
# !END Animation
