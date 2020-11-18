extends Node2D

export var MAX_SIZE = Vector2.ZERO
export var MIN_SIZE = Vector2.ZERO

export var TILESET: NodePath

var width = 0
var height = 0
var tilemap: TileMap

func _ready():
	tilemap = get_node(TILESET)
	width = (randi() % int(MAX_SIZE.x)) + MIN_SIZE.x
	height = (randi() % int(MAX_SIZE.y)) + MIN_SIZE.y
	
	if width < MIN_SIZE.x: width = MIN_SIZE.x
	if height < MIN_SIZE.y: height = MIN_SIZE.x
	
	for y in range(height):
		for x in range(width):
			print(str(y * tilemap.cell_size.x) + " " + str(x * tilemap.cell_size.y))
			tilemap.set_cell(y, x, randi() % tilemap.tile_set.get_tiles_ids().size(), randi() % 2 == 0, randi() % 2 == 0)
