extends KinematicBody2D

var action = "idle"
var actionFrame = 0

func _process(_delta):
	input()
	animate()
	
func input():
	
	var input = Vector2.ZERO
	
	if Input.is_action_just_pressed("player_attack"):
		$Attack.start(self, $Movement)
	
	if action == "attack": return
	
	if Input.is_action_pressed("player_up"):
		input.y += -1
	if Input.is_action_pressed("player_down"):
		input.y += 1
	if Input.is_action_pressed("player_left"):
		input.x += -1
	if Input.is_action_pressed("player_right"):
		input.x += 1
		
	$Movement.move(self, input)
	
	action = "walk" if $Movement.is_moving() else "idle"

# !START Attack
func _on_Attack_start():
	play_random_frame("attack")
	$Camera2D.shake(10.0, 0.1)

func _on_Attack_stop():
	play_random_frame("idle")

func _on_Attack_hit(body):
	# break breakable shit
	if body.is_in_group("breakable"):
		body.get_node("CollisionShape2D").free()
		body.get_node("AnimatedSprite").play("break")
# !END Attack

# !START Animation
func get_animation():
	return action + "_" + $Movement.get_direction()
	
func play_random_frame(animation = null):
	if animation != null: action = animation
	$AnimatedSprite.play(get_animation())
	$AnimatedSprite.frame = randi() % $AnimatedSprite.frames.get_frame_count(get_animation())
	
func animate():
	$AnimatedSprite.play(get_animation())
# !END Animation
