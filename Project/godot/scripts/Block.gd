extends TileMap

func _ready():
	for child in $Cameras.get_children():
		child.connect("body_entered", self, "Area2D_Camera_Body_Entered", [child])
	
func Area2D_Camera_Body_Entered(body, area):
	if body.is_in_group("player"):
		Game.get_camera().move(area.get_node("Position2D").global_position)
		Game.get_camera().rotate(area.get_node("Position2D").rotation_degrees)
