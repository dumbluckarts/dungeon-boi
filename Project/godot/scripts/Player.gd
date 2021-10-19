extends KinematicBody2D

var input = Vector2.ZERO
var direction = "down"
var velocity = Vector2.ZERO
var animation = ""

func _physics_process(delta):
	input = _get_input()
	direction = _get_direction()
	velocity = _move_player(input, delta)
	animation = _animate_player()

func _get_input() -> Vector2:
	var x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")
	var y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
	return Vector2(x, y).normalized()
func _get_direction() -> String:
	var result = direction
	if velocity != Vector2.ZERO:
		if velocity.x > 0: result = "right"
		if velocity.x < 0: result = "left"
		if velocity.y > 0: result = "down"
		if velocity.y < 0: result = "up"
	return result
func _move_player(input: Vector2, delta: float) -> Vector3:
	return $Movement.move(self, input, delta)
func _animate_player() -> String:
	var result = ""
	if velocity != Vector2.ZERO:
		result = "walk"
		$AnimationPlayer_Steps.play("Steps")
		if direction == "left" or direction == "right":
			$Particles2D_Footsteps.emitting = true
			$Particles2D_Footsteps2.emitting = true
			$Particles2D_Footsteps3.emitting = false
			$Particles2D_Footsteps4.emitting = false
		else:
			$Particles2D_Footsteps3.emitting = true
			$Particles2D_Footsteps4.emitting = true
			$Particles2D_Footsteps.emitting = false
			$Particles2D_Footsteps2.emitting = false
	else:
		result = "default"
		$AnimationPlayer_Steps.stop()
		$Particles2D_Footsteps.emitting = false
		$Particles2D_Footsteps2.emitting = false
		$Particles2D_Footsteps3.emitting = false
		$Particles2D_Footsteps4.emitting = false
	$AnimatedSprite.play(result + "_" + direction)
	
	if Input.is_action_pressed("player1_action2"):
		$AnimationPlayer_Steps.playback_speed = 1.5
		$AnimatedSprite.speed_scale = 1.5
		$Particles2D.emitting = true
	else:
		$AnimationPlayer_Steps.playback_speed = 1
		$AnimatedSprite.speed_scale = 1
		$Particles2D.emitting = false
	
	return result
