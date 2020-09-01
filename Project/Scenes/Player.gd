extends "res://Script/2dMovement.gd"

class_name Player

export var ATTACK_LENGTH = 0.1
export var ATTACK_MULTIPLIER = 1.0

var action = "idle"
var actionFrame = 0

func _process(_delta):
	animate()
	input()
	move()
	
func input():
	
	if Input.is_action_just_pressed("player_attack"):
		attack()
	
	if action == "attack": return
	
	if Input.is_action_pressed("player_up"):
		action = "walk"
		up()
	elif Input.is_action_pressed("player_down"):
		action = "walk"
		down()
	elif Input.is_action_pressed("player_left"):
		action = "walk"
		left()
	elif Input.is_action_pressed("player_right"):
		action = "walk"
		right()
	else:
		action = "idle"
		stop()
		
# !START Attack
func attack_direction():
	if direction == "up":
		up()
		$RayCast2D.cast_to = velocity * 128
	elif direction == "down":
		down()
		$RayCast2D.cast_to = velocity * 128
	elif direction == "left":
		left()
		$RayCast2D.cast_to = velocity * 128
	elif direction == "right":
		right()
		$RayCast2D.cast_to = velocity * 128
		
	$PunchSprite.visible = true
	$PunchSprite.position = $RayCast2D.cast_to / 1.2 + \
		(Vector2(velocity.y, velocity.x) * rand_range(0, 32))
	$PunchSprite.play(direction)
	$PunchSprite.frame = randi() % $PunchSprite.frames.get_frame_count(direction)
	$PunchSprite.modulate.a8 = 255
	$PunchSprite/Timer.stop()
	$PunchSprite/Timer.start()

func attack():
	var timer = Timer.new()
	
	add_child(timer)
	
	timer.set_wait_time(ATTACK_LENGTH)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "unattack", [ $RayCast2D ])
	timer.connect("timeout", timer, "queue_free")
	timer.start()
	
	speed_multiplier = ATTACK_MULTIPLIER
	action = "attack"
	
	attack_direction()
	
	$Camera2D.shake(5.0, 0.1)
	
	$RayCast2D.enabled = true
	$AnimatedSprite.play(get_animation())
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count(get_animation())
	
func unattack(raycast):
	speed_multiplier = 1.0
	raycast.enabled = false
	action = "idle"
	
func _on_RayCast2D_collide(body):
	if body.has_node("AnimationPlayer"):
		print ("Holyyy")
	
# !END Attack

# !START Animation
func get_animation():
	return action + "_" + direction
	
func animate():
	$AnimatedSprite.play(get_animation())
# !END Animation
