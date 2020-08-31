extends RayCast2D

signal collide(body)

func _process(_delta):
	if is_colliding():
		emit_signal("collide", get_collider())
		enabled = false
