extends Area2D

export var FLIPPED = false
export var COLLISION_SIZE = Vector2.ZERO

func _ready():
	$CollisionShape2D.scale = COLLISION_SIZE

func _process(delta):
	for body in get_overlapping_bodies():
		if not body.is_in_group("player"): continue
	
		var adjust = 0 if not FLIPPED else -1
	
		$"../".z_index = 1 * adjust if  $"../".transform.origin.y > body.transform.origin.y else -1 * adjust
