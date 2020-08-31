extends Camera2D

var is_shake = false
var shake_strength = 0.0

func _ready():
	randomize()
	
func _process(_delta):
	if is_shake:
		offset = Vector2(rand_range(0, shake_strength), rand_range(0, shake_strength))
	
func shake(strength, length):
	shake_strength = strength
	is_shake = true
	
	var timer = Timer.new()
	
	add_child(timer)
	
	timer.set_wait_time(length)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "stop_shake")
	timer.connect("timeout", timer, "queue_free")
	timer.start()
	
func stop_shake():
	is_shake = false
	offset = Vector2(0, 0)
