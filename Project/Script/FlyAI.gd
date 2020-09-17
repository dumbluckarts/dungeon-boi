extends Node2D

signal move(direction)
signal stop(direction)
signal start_attack(direction)
signal stop_attack(direction)

var state = "idle"
var history = []

func process(start: KinematicBody2D, finish: KinematicBody2D):
	
	var direction = get_direction_to(start, finish)
	var distance = get_distance_to(start, finish)
	var objects = get_colliding(start, finish)

	# Be wary of close objects
	for key in objects:
		var object_direction = objects[key]["direction"]
		var object_distance = objects[key]["distance"]
		
		if object_distance < 60: continue
		
		direction -= object_direction * 0.5
		
	history.append(direction)
	
	# Detect being stuck
	var negatives = 0
	var positives = 0
	
	for old_direction in history:
		if old_direction < Vector2(0, 0): negatives += 1
		if old_direction > Vector2(0, 0): positives += 1

	if negatives != 0 and positives != 0:
		var divided = float(negatives) / float(positives)
		var flipping = divided >= 1
		
		if flipping: state = "stuck"
		
	# Try and move away from stuck spot
	if state == "stuck":
		direction = get_direction_to(start, finish)
		direction = direction.rotated(-43)

	emit_signal("move", direction)

func get_direction_to(start: KinematicBody2D, finish: Node2D):
	return start.transform.origin.direction_to(finish.transform.origin)

func get_distance_to(start: KinematicBody2D, finish: Node2D):
	return start.transform.origin.distance_to(finish.transform.origin)

func get_colliding(start: KinematicBody2D, finish: Node2D):
	var result = {}
	var objects = $Area2D.get_overlapping_bodies()
	
	objects.remove($Area2D.get_overlapping_bodies().find(start))
	objects.remove($Area2D.get_overlapping_bodies().find(finish))
	
	for object in objects:
		result[str(object)] = {
			"direction": get_direction_to(start, object),
			"distance": get_distance_to(start, object)
		}
	
	return result

func _on_ClearStuckTimer_timeout():
	if state == "stuck": state = "idle"

func _on_ClearHistoryTimer_timeout():
	history.clear()
