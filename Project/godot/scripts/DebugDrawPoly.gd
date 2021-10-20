extends CollisionPolygon2D

export var DEBUG = true

func _draw():
	draw_polygon(polygon, [ Color(1, 0, 0, 0.5) ], [], null, null, true)

func _process(delta):
	if DEBUG: update()
