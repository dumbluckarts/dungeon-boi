extends Node2D

export var SPEED = 100

var _speed_multiplier = 1.0
var _velocity = Vector2.ZERO
var _direction = "down"
var _moving = false

var Direction = {
	"up": Vector2.UP,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"stop": Vector2.ZERO
}

func get_speed_multiplier():
	return _speed_multiplier

func get_velocity():
	return _velocity

func get_direction():
	return _direction
	
func is_moving():
	return _moving 

func set_speed_multiplier(value):
	_speed_multiplier = value 

func set_velocity(value):
	_velocity = value 

func set_direction(value):
	_direction = value

func move(body: KinematicBody2D, direction: String):
	if direction != "stop":
		_direction = direction	
	
	_moving = direction != "stop"
	_velocity = Direction[direction]

	return body.move_and_slide((Direction[direction] * SPEED) * _speed_multiplier, Vector2.UP)

