extends KinematicBody2D

export var SPEED = 0

var velocity = Vector2.ZERO
var travelling = true

func _process(delta):
	if travelling == false: return
	track()
	move()
	
func move():
	move_and_slide(velocity * SPEED, Vector2.UP)
	
func track():
	var player = $"../WallTiles/Player"
	var position = player.transform.origin

	if position.distance_to(transform.origin) < 180:
		velocity = Vector2.ZERO
		travelling = false
		explode()
		return

	if transform.origin.x > position.x:
		velocity.x = -1
	else:
		velocity.x = 1
		
	if transform.origin.y > position.y:
		velocity.y = -1
	else:
		velocity.y = 1
		
func explode():
	$AnimatedSprite.modulate.g8 = 50
	$AnimatedSprite.modulate.b8 = 50
	$ExplodeTimer.start()

func _on_ExplodeTimer_timeout():
	var camera = $"../WallTiles/Player/Camera2D"
	
	camera.shake(15, 0.1)
	
	$Particles2D.emitting = true
	$AnimatedSprite.visible = false
	$DropShadow.visible = false
	$CollisionShape2D.disabled = true
	
	var timer = get_tree().create_timer(2)
	timer.connect("timeout", self, "queue_free")
