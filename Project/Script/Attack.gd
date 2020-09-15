extends Node2D

signal start
signal stop
signal hit(body)

export var ATTACK_LENGTH = 1.0
export var ATTACK_MULTIPLIER = 1.0

func start(body: KinematicBody2D, movement: Node2D):
	var timer = get_tree().create_timer(ATTACK_LENGTH)
	
	timer.connect("timeout", self, "stop", [ movement ])
	timer.connect("timeout", timer, "queue_free")
	
	# Set movement multiplier
	movement.set_speed_multiplier(ATTACK_MULTIPLIER)
	movement.move(body, movement.get_direction())
	
	# Emit attack signal
	emit_signal("start")
	
	# Enable collision
	$PunchSprite/Area2D/CollisionShape2D.disabled = false
	
	# Set raycast direction
	$RayCast2D.cast_to = movement.get_velocity() * 128
	$RayCast2D.enabled = true
	
	# Animated punch sprite
	$PunchSprite.visible = true
	$PunchSprite.position = $RayCast2D.cast_to
	$PunchSprite.play(movement.get_direction())
	$PunchSprite.frame = randi() % $PunchSprite.frames.get_frame_count(movement.get_direction())
	$PunchSprite.modulate.a8 = 120
	$PunchSprite/Timer.stop()
	$PunchSprite/Timer.start()
	
func stop(movement: Node2D):
	movement.set_speed_multiplier(1.0)
	
	$RayCast2D.enabled = false
	$PunchSprite/Area2D/CollisionShape2D.disabled = true
	
	emit_signal("stop")

func _on_Area2D_body_entered(body):
	emit_signal("hit", body)
