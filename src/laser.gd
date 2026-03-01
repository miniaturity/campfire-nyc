
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

## The length of the laser.
@export var laser_length: float = 1000.0

## Laser color
@export var color: Color = Color(255, 0, 0)

func disable():
	active = false
	raycast.enabled = false
	line_2d.visible = false

func enable():
	active = true
	raycast.enabled = true
	line_2d.visible = true

func _ready() -> void:
	line_2d.default_color = color
	raycast.target_position = Vector2.UP * laser_length
	raycast.enabled = true
	line_2d.add_point(Vector2(0,0))
	line_2d.add_point(raycast.target_position)

func _physics_process(_delta: float) -> void:
	if not active: return
	line_2d.set_point_position(1, raycast.target_position)
	if not raycast.is_colliding(): return
	
	var collider = raycast.get_collider()
	if not (collider is Node2D): return
	collider = collider as Node2D
	line_2d.set_point_position(1, to_local(raycast.get_collision_point()))
	
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
