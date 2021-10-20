extends Node2D

export var DEBUG = true

func _draw():
	var line1 = Vector2(32, 0)
	var line2 = Vector2(-32, 0)
	var line3 = Vector2(0, 32)
	var line4 = Vector2(0, -32)
	draw_line(line1, line2, Color(1, 0, 0, 0.5), 8)
	draw_line(line3, line4, Color(0, 1, 0, 0.5), 8)

func _process(delta):
	if DEBUG: update()
