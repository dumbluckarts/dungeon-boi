extends KinematicBody2D

var timer = Timer.new()
var target = Vector2.ZERO

func _ready():
	timer.one_shot = false
	timer.wait_time = rand_range(1.5, 2.0)
	timer.autostart = true
	timer.connect("timeout", self, "_aquire_target")
	add_child(timer)

func _physics_process(delta):
	if target != Vector2.ZERO:
		$Movement.move(self, global_position.direction_to(target), delta)
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("default")
	var left = global_position - Vector2(16, 16) < target
	var right = global_position + Vector2(16, 16) > target
	if left and right:
		target = Vector2.ZERO

func _aquire_target():
	var player = Game.get_player()
	target = player.global_position
	target += Vector2(rand_range(-256, 256), rand_range(-256, 256))
	target = target.round()
	timer.wait_time = rand_range(1.5, 2.0)
