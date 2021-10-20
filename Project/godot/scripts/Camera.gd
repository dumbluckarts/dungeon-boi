extends Camera2D
class_name GameCamera

var to = Vector2.ZERO
var ro = .0

var is_shake = false
var shake_strength = 0.0
var is_zoom = false
var zoom_strength = Vector2(1.1, 1.1)
onready var zoom_strength_max = zoom
var is_rotate = false
var rotate_strength = 0.0

func _ready():
	randomize()
	
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
	for i in range(ceil(shake_strength)):
		yield(get_tree().create_timer(i * 0.01), "timeout")
		lerp_shake()

func lerp_shake():
	shake_strength -= 1
	
	if shake_strength <= 0:
		is_shake = false
		shake_strength = 0.0

func move(to: Vector2):
	self.to = to
	
func rotate(to: float):
	self.ro = to
	
func _physics_process(delta):
	global_position = (to + Game.get_player().global_position) / 2
	rotation_degrees = lerp(rotation_degrees, ro, 0.01)
	if is_shake:
		offset = Vector2(rand_range(0, shake_strength), rand_range(0, shake_strength))
