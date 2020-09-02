extends AnimatedSprite

func _ready():
	randomize()
	frame = randi() % frames.get_frame_count("default")
