extends Node
#
#export var SIZE = Vector2.ZERO
#export var CAVE_NOISE: OpenSimplexNoise
#export var DETAIL_NOISE: OpenSimplexNoise
#
#func _process(delta):
#	_generate()
#
#func _ready():
#	SIZE += Vector2(2, 2)
#	CAVE_NOISE.seed = OS.get_unix_time()
#	DETAIL_NOISE.seed = OS.get_unix_time()
#
#func _generate():
#	_generate_floor()
#
#func _generate_floor():
#	var middle_top = Vector2(SIZE.x / 2, 0)
#	var middle_bottom = Vector2(SIZE.x / 2, SIZE.y-1)
#	var middle_left = Vector2(0, SIZE.y / 2)
#	var middle_right = Vector2(SIZE.x-1, SIZE.y / 2)
#
#	for y in range(SIZE.y):
#		for x in range(SIZE.x):
#			var position = Vector2(x, y)
#			var cave_noise = CAVE_NOISE.get_noise_2dv(position)
#			var detail_noise = DETAIL_NOISE.get_noise_2dv(position)
#			var cell = 1 if rand_range(0, 100) > 20 else 2
#
#			if detail_noise > 0: cell = 18
#			if cave_noise > 0.4: cell = -1
#
#			if position.x == 0 \
#				or position.y == 0 \
#				or position.x == SIZE.x -1 \
#				or position.y == SIZE.y -1:
#					cell = 3
#			if position == middle_top: cell = 5
#			if position == middle_bottom: cell = 5
#			if position == middle_left: cell = 5
#			if position == middle_right: cell = 5
#
#			$TileMap.set_cellv(position, cell)
