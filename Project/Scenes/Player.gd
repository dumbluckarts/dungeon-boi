extends KinematicBody2D

export var VERTICAL_SPEED = 100
export var HORIZONTAL_SPEED = 100
export var ATTACK_MULTIPLIER = 2

var velocity = Vector2.ZERO
var direction = "down"
var action = "idle"
var actionFrame = 0

func _ready():
	$Timer.connect("timeout", self, "unattack", [ $RayCast2D ])

func _process(_delta):
	input()
	move()
	animate()
	attack_direction()
	
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
		
	if Input.is_action_just_pressed("player_attack"):
		attack()
	
# !START Attack
func attack_direction():
	if direction == "up":
		$RayCast2D.cast_to = Vector2(0, 128)
		velocity = Vector2(0, -VERTICAL_SPEED)
	elif direction == "down":
		$RayCast2D.cast_to = Vector2(0, -128)
		velocity = Vector2(0, VERTICAL_SPEED)
	elif direction == "left":
		$RayCast2D.cast_to = Vector2(-128, 0)
		velocity = Vector2(-HORIZONTAL_SPEED, 0)
	elif direction == "right":
		$RayCast2D.cast_to = Vector2(128, 0)
		velocity = Vector2(HORIZONTAL_SPEED, 0)

func attack():
	$Timer.start()
	$RayCast2D.enabled = true
	action = "attack"
	actionFrame = randi() % 2
	
func unattack(raycast):
	raycast.enabled = false
	action = "idle"
# !END Attack
	
# !START Movement
func move():
	if action == "attack":
		move_and_slide(velocity * ATTACK_MULTIPLIER, Vector2.UP)
	else:
		move_and_slide(velocity, Vector2.UP)

func up():
	if action != "attack":
		direction = "up"
		action = "walk"
	velocity = Vector2(0, -VERTICAL_SPEED)
	
func down():
	if action != "attack":
		direction = "down"
		action = "walk"
	velocity = Vector2(0, VERTICAL_SPEED)
	
func left():
	if action != "attack":
		direction = "left"
		action = "walk"
	velocity = Vector2(-HORIZONTAL_SPEED, 0)
	
func right():
	if action != "attack":
		direction = "right"
		action = "walk"
	velocity = Vector2(HORIZONTAL_SPEED, 0)
	
func stop():
	if action != "attack":
		action = "idle"
		velocity = Vector2.ZERO
# !END Movement

# !START Animation
func get_animation():
	return action + "_" + direction
	
func animate():
	$AnimatedSprite.play(get_animation())
	
	if action == "attack":
		$AnimatedSprite.frame = actionFrame
# !END Animation
