extends AnimatedSprite

var timer = Timer.new()
var target: Vector2

func _ready():
	timer.wait_time = rand_range(1, 5)
	timer.one_shot = false
	timer.connect("timeout", self, "_move")
	add_child(timer)
	timer.start()
	target = global_position
	
func _physics_process(delta):
	var direction = global_position.direction_to(target).normalized().round()
	global_position += direction * 0.5
	if global_position.round() == target.round():
		target = global_position
	
func _move():
	target = global_position + Vector2(rand_range(-100, 100), rand_range(-100, 100))
	var direction = global_position.direction_to(target).normalized().round()
	if direction.x > 0:
		flip_h = false
	else:
		flip_h = true
