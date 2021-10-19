extends Sprite

func _process(delta):
	var pos = Game.get_player().get_global_transform_with_canvas().origin + Vector2(0, -64)
	transform.origin = transform.origin.linear_interpolate(pos, 0.1)
	look_at(Game.get_player().get_global_transform_with_canvas().origin)
#	rotation = transform.origin.direction_to(pos)
