extends KinematicBody2D

export var BEHAVIORS = [
	"attack",
	"avoid_solids",
	"avoid_stuck",
	"avoid_finish",
]

func _process(delta):
	$AI.process(self, $"../Player", BEHAVIORS)
	
func _on_AI_move(direction):
	$Movement.move(self, direction)

func _on_AI_post_process(start, finish):
	pass # Replace with function body.

func _on_AI_start_attack(direction):
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	$AI.stop_attack()

func _on_AI_stop_attack(direction):
	print("ive been set to idle")
