
class_name Laser
extends Node2D

@onready var line_2d = $Line2D
@onready var raycast = $StaticBody2D/RayCast2D
@onready var collision = $StaticBody2D

## Whether it is a start or endpoint
## Prevents drawing laser twice
@export var start: bool = true

## Other laser to connect to.
@export var other: Laser

## Laser on/off by default.
@export var active: bool = true
## Whether it can be blocked by boxes or not.
@export var blockable: bool = true

## Laser color
@export var color: Color = Color(255, 0, 0)

var end_pos: Vector2

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
	
	line_2d.default_color = color
	line_2d.points = [Vector2(0, 0), to_local(other.global_position)]
	if blockable:
		raycast.target_position = to_local(other.global_position)

	
func _physics_process(_delta: float) -> void:
	if !start || line_2d.points[1] == Vector2(0, 0) || !blockable: return
	
	if !active:
		raycast.enabled = false
		if collision.collision_layer != 4:
			collision.collision_layer = 4
		line_2d.self_modulate.a = 0
	else:
		raycast.enabled = true
		if collision.collision_layer != 2:
			collision.collision_layer = 2
		line_2d.self_modulate.a = 1
		
		if raycast.is_colliding():
			var global_pt = raycast.get_collision_point()
			var local_pt = raycast.to_local(global_pt)
			
			if local_pt:
				line_2d.points = [Vector2(0, 0), local_pt]
