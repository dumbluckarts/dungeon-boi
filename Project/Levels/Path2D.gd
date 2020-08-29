extends Path2D

export var SPEED = 100

func _process(delta):
		$PathFollow2D.set_offset($PathFollow2D.get_offset() + SPEED * delta)
