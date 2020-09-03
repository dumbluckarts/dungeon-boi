extends Path2D

export var SPEED = 1

func _process(_delta):
	$PathFollow2D.set_offset($PathFollow2D.offset + SPEED)
