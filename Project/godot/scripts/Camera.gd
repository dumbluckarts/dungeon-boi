extends Camera2D
class_name GameCamera

var to = Vector2.ZERO
var ro = .0

func move(to: Vector2):
	self.to = to
	
func rotate(to: float):
	self.ro = to
	
func _physics_process(delta):
	global_position = (to + Game.get_player().global_position) / 2
	rotation_degrees = lerp(rotation_degrees, ro, 0.01)
