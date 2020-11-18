extends KinematicBody2D

export var BEHAVIORS = [
	"follow_finish",
#	"avoid_solids",
#	"avoid_stuck",
]

export var FLOAT_DURATION: float = 0
export var FLOAT_MAGNITUDE: float = 0

var float_scalar = 1
	
func _ready():
	# floating timer
	var timer = Timer.new()
	
	add_child(timer)
	
	timer.set_wait_time(FLOAT_DURATION)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "flip_sin")
	timer.start()

func _process(delta):
	$AI.process(self, $"../Player", BEHAVIORS)
	animate()
	
func _on_AI_move(direction):
	$Movement.move(self, direction)
	
func animate():
	if transform.origin.x > $"../Player".transform.origin.x:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	var from = $Sprite.transform.origin.y
	var to = $Sprite.transform.origin.y + (float_scalar * FLOAT_MAGNITUDE)

	$Sprite.transform.origin.y = lerp(from, to, 0.1)

func flip_sin():
	float_scalar *= -1
	
