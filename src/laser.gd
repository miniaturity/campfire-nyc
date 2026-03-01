
class_name Laser
extends Node2D

@onready var line_2d = $Line2D

## Whether it is a start or endpoint
## Prevents drawing laser twice
@export var start: bool = true

## Other laser to connect to.
@export var other: Laser

## Laser on/off by default.
@export var active: bool = true
## Whether it can be blocked by boxes or not.
@export var blockable: bool = true

func disable():
	active = false

func enable():
	active = true

func _ready() -> void:
	# Dont need to do anything if its the endpoint.
	if !start: 
		return
	if !other:
		push_error("A laser point was not connected!")
		return
		
	if other.start:
		push_error("Duplicate starting points for a laser!")
		return
	
	line_2d.points = [Vector2.ZERO, Vector2.ZERO]

func _process(_delta: float) -> void:
	if !start || !active: return
	var start_pos = to_local(global_position)
	var end_pos = to_local(other.global_position)
	
	print("StartPos: " + str(start_pos))
	print("EndPos: " + str(end_pos))
	line_2d.points = [start_pos, end_pos]
	
