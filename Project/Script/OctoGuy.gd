extends KinematicBody2D

var BEHAVIORS = [
#	'follow_finish',
#	'avoid_solids',
#	'avoid_stuck'
]

func _process(delta):
	$AI.process(self, $"../Player", BEHAVIORS)
	animate()

func _on_AI_move(direction):
	$Movement.move(self, direction)

func animate():
	if $Movement.is_moving():
		$AnimatedSprite.play("walking")
	else:
		$AnimatedSprite.play("default")
	
	if transform.origin.x > $"../Player".transform.origin.x:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
