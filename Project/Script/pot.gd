extends StaticBody2D

func _on_AnimatedSprite_animation_finished():
	$CollisionShape2D.disabled = true
