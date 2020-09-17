extends Node2D

signal pre_process(start, finish)
signal post_process(start, finish)
signal move(direction)
signal stop(direction)
signal start_attack(direction)
signal stop_attack(direction)

export var FINISH_STOP_DISTANCE = 0
export var SOLIDS_STOP_DISTANCE = 0
export var ATTACK_STOP_DISTANCE = 0
export var ATTACK_RANGE = Vector2(0, 0)

var state = "idle"
var direction: Vector2
var distance: float
var objects: Dictionary
var history = []

func get_state(): return state
func get_direction(): return direction
func get_distance(): return distance
func get_objects(): return objects
func get_history(): return history
func set_state(value: String): state = value
func set_direction(value: Vector2): direction = value
func set_distance(value: float): distance = value
func set_objects(value: Dictionary): objects = value
func set_history(value: Array): history = value

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

func process(start: KinematicBody2D, finish: KinematicBody2D, behaviors: Array = []):
	
	direction = Vector2.ZERO
	distance = get_distance_to(start, finish)
	objects = get_colliding(start, finish)

	emit_signal("pre_process", start, finish)

	for behavior in behaviors:
		if state == "idle": direction = call(behavior, start, finish)
		
	emit_signal("post_process", start, finish)
	emit_signal("move", direction)

# Behaviors
func follow_finish(start, finish):
	return get_direction_to(start, finish) 

func avoid_finish(start, finish):
	var result = distance

	if result > FINISH_STOP_DISTANCE: return follow_finish(start, finish)
			
	result = get_direction_to(start, finish).rotated(180)

	return result

func avoid_solids(start, finish):
	var result = direction
	
	# Be wary of close objects
	for key in objects:
		var object_direction = objects[key]["direction"]
		var object_distance = objects[key]["distance"]
		
		if object_distance < SOLIDS_STOP_DISTANCE: continue
		
		result -= object_direction * 0.5

	history.append(result)

	return result
	
func avoid_stuck(start, finish):
	var result = direction
	
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
		result = get_direction_to(start, finish)
		result = result.rotated(-43)
		
	return result
	
func attack(start, finish):
	if distance < ATTACK_RANGE.x or distance > ATTACK_RANGE.y: return direction
	state = "attack"
	emit_signal("start_attack", direction)
	
	return Vector2.ZERO

func stop_attack():
	state = "idle"
	emit_signal("stop_attack", direction)
	
# Timers	
func _on_ClearStuckTimer_timeout():
	if state == "stuck": state = "idle"

func _on_ClearHistoryTimer_timeout():
	history.clear()
