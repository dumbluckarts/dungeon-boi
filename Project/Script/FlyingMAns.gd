extends KinematicBody2D

func _process(delta):
	$AI.process(self, $"../Player")
	
func _on_AI_move(direction):
	$Movement.move(self, direction)
