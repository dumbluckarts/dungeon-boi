extends KinematicBody2D

export var ANIM_WALK_FPS = 10
export var ANIM_RUN_FPS = 15

var input = Vector2.ZERO
var input_lock = Vector2.ZERO
var direction = "down"
var velocity_scale = 1.0
var velocity = Vector2.ZERO
var animation = ""
var attack = ""

func _physics_process(delta):
	input = _get_input()
	direction = _get_direction()
	velocity = _move(input, delta)
	animation = _animate()
	attack = _attack()

func _get_input() -> Vector2:
	if input_lock != Vector2.ZERO: return input_lock
	
	var x = Input.get_action_strength("player1_right") - Input.get_action_strength("player1_left")
	var y = Input.get_action_strength("player1_down") - Input.get_action_strength("player1_up")
	var vec = Vector2(x, y).normalized()
	
	if vec != Vector2.ZERO: $Direction.rotation = vec.angle()
	
	return vec
func _get_direction() -> String:
	var result = direction
	if velocity != Vector2.ZERO:
		if velocity.x > 0: result = "right"
		if velocity.x < 0: result = "left"
		if velocity.y > 0: result = "down"
		if velocity.y < 0: result = "up"
	return result
func _move(input: Vector2, delta: float) -> Vector3:
	if attack == "lunge" or attack == "pound":
		velocity_scale = lerp(velocity_scale, 0, 0.06)
		if velocity_scale < 0.05: 
			attack = ""
			input_lock = Vector2.ZERO
	elif Input.is_action_pressed("player1_action2"): 
		velocity_scale = 1.5
	else: 
		velocity_scale = lerp(velocity_scale, 1.0, 0.2)
	
	return $Movement.move(self, input, delta, velocity_scale)
func _attack():
	# base attack
	var result = ""
	if Input.is_action_just_pressed("player1_action1"): result = "base"
	# lunge attack
	if Input.is_action_just_pressed("player1_action1") \
		and Input.is_action_pressed("player1_action2"): result = "lunge"	
	if result == "base" and attack == "lunge": return attack
	if result == "base" and attack == "pound": return attack
	if result == "lunge" and attack == "pound": return attack
	if result == "lunge" and attack == "pound": return attack
	
	if result == "lunge" and attack == "lunge": 
		var area = Area2D.new()
		for child in $Direction/Position2D.get_children():
			$Direction/Position2D.remove_child(child)
		_add_hitbox(Vector2(256, 256), 0.1, 0.8, false)
		result = "pound"
	elif result == "base":
		_add_hitbox(Vector2(88, 88), .1, .0, true, true)
		Game.get_camera().shake(5, 0.1)
		velocity_scale = -2.5
	elif result == "lunge":
		_add_hitbox(Vector2(128, 64), 0.8)
		Game.get_camera().shake(10, 0.1)
		velocity_scale = 3.5
		input_lock = input
	
	return result if not result == "" else attack
		
func _animate() -> String:
	return "default"
	
func _get_square(extents: Vector2):
	return [
		Vector2(extents.x, extents.y),
		Vector2(-extents.x, extents.y),
		Vector2(-extents.x, -extents.y),
		Vector2(extents.x, -extents.y),
	]
func _add_hitbox(extents: Vector2, decay: float = .1, wait: float = .0, directional: bool = true, spawn_slash: bool = false):
	var area = Area2D.new()
	var poly = CollisionPolygon2D.new()
	var t = Timer.new()
	
	poly.polygon = _get_square(extents)
	poly.set_script(load("res://godot/scripts/DebugDrawPoly.gd"))
	area.add_child(poly)
	
	t.one_shot = true
	t.autostart = true
	t.wait_time = decay
	t.connect("timeout", area, "queue_free")
	t.connect("timeout", t, "queue_free")
	
	if (wait != 0.0):
		var t2 = Timer.new()
		t2.one_shot = true
		t2.autostart = true
		t2.wait_time = wait
		add_child(t2)
		yield(t2, "timeout")
	
	add_child(t)
	if directional:
		$Direction/Position2D.add_child(area)
	else:
		$Direction.add_child(area)
	
	if spawn_slash:
		var slash = load("res://godot/scenes/Slash.tscn").instance()
		$Direction/Position2D.add_child(slash)
		t.connect("timeout", slash, "queue_free")

#	var result = ""
#	if velocity != Vector2.ZERO:
#		if Input.is_action_just_pressed("player1_action1"):
#			$AudioStreamPlayer2D_Slide.play()
#			velocity_scale = 3.0
#			Game.get_camera().shake(10.0, 1.0)
#		if Input.is_action_just_released("player1_action1"):
#			$AudioStreamPlayer2D_Slide.stop()
#		if Input.is_action_pressed("player1_action2") and Input.is_action_pressed("player1_action1"):
#			result = "jab"
#		else:
#			result = "walk"
#		$AnimationPlayer_Steps.play("Steps")
#		if direction == "left" or direction == "right":
#			$Particles2D_Footsteps.emitting = true
#			$Particles2D_Footsteps2.emitting = true
#			$Particles2D_Footsteps3.emitting = false
#			$Particles2D_Footsteps4.emitting = false
#		else:
#			$Particles2D_Footsteps3.emitting = true
#			$Particles2D_Footsteps4.emitting = true
#			$Particles2D_Footsteps.emitting = false
#			$Particles2D_Footsteps2.emitting = false
#	else:
#		result = "default"
#		$AnimationPlayer_Steps.stop()
#		$Particles2D_Footsteps.emitting = false
#		$Particles2D_Footsteps2.emitting = false
#		$Particles2D_Footsteps3.emitting = false
#		$Particles2D_Footsteps4.emitting = false
#
#	$AnimationPlayer_Sprite.play(result + "_" + direction)
#
#	if Input.is_action_pressed("player1_action2"):
#		$AnimationPlayer_Steps.playback_speed = velocity_scale
#		$AnimationPlayer_Sprite.playback_speed = ANIM_RUN_FPS
#		$Particles2D.emitting = true
#		if Input.is_action_pressed("player1_action1"):
#			velocity_scale = lerp(velocity_scale, 0, 0.05)
#			$Particles2D_Slide.emitting = true
#			$AnimationPlayer_Steps.stop()
#			$AnimationPlayer_Sprite.playback_speed = 10.0
#		else:
#			velocity_scale = 1.5
#			$Particles2D_Slide.emitting = false
#	else:
#		velocity_scale = 1.0
#		$Particles2D_Slide.emitting = false
#		$AnimationPlayer_Steps.playback_speed = velocity_scale
#		$AnimationPlayer_Sprite.playback_speed = ANIM_WALK_FPS
#		$Particles2D.emitting = false
#
#	return result
