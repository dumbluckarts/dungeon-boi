extends Node2D

func _ready():
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count($AnimatedSprite.get_animation())
