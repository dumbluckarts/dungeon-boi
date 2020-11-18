extends TileMap

var cursor = Vector2.ZERO

func _ready():

	randomize()
	
	var width = randi() % 7 + 5
	var height = randi() % 7 + 5
	var middle_top
	var middle_bottom
	var middle_left
	var middle_right
	
	for y in range(height):
		for x in range(width):
			var position = Vector2(x, y)
			
			if (x == round(width/2) and y == 0): middle_top = position
			if (x == round(width/2) and y == height-1): middle_bottom = position
			if (y == round(height/2) and x == 0): middle_left = position
			if (y == round(height/2) and x == width-1): middle_right = position
			if (x == 0 and y == 0):
				set_cellv(position, 5)
				continue
			if (x == width-1 and y == 0):
				set_cellv(position, 5, true)
				continue
			if (x == 0 and y == height-1):
				set_cellv(position, 5, false, true)
				continue
			if (x == width-1 and y == height-1):
				set_cellv(position, 5, true, true)
				continue
			if (y == 0):
				set_cellv(position, 6)
				continue
			if (y == height-1):
				set_cellv(position, 6, false, true)
				continue
			if (x == 0):
				set_cellv(position, 6, false, true, true)
				continue
			if (x == width-1):
				set_cellv(position, 6, true, true, true)
				continue

			set_cellv(position, randi() % 3)
			
	var top = {
		"position": middle_top,
		"x": false,
		"y": false,
		"z": false
	}
	
	var bottom = {
		"position": middle_bottom,
		"x": true,
		"y": true,
		"z": false
	}
	
	var left = {
		"position": middle_left,
		"x": false,
		"y": true,
		"z": true
	}
	
	var right = {
		"position": middle_right,
		"x": true,
		"y": false,
		"z": true
	}
			
	var amount = round(rand_range(2, 4))
	var doors = [ top, bottom, left, right ]
			
	for i in range(amount):
		doors.shuffle()
			
		set_cellv(doors[0].position, 4, doors[0].x, doors[0].y, doors[0].z)

		doors.pop_front()
