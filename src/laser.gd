class_name Laser
extends Node2D

@onready var line_2d = $Line2D
@onready var raycast = $RayCast2D
@onready var collision = $StaticBody2D

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
	var collider = raycast.get_collider()
	line_2d.set_point_position(1, to_local(raycast.get_collision_point()))
	if not (collider is Node2D): return
	collider = collider as Node2D
	
	if collider.is_in_group(&"Players"):
		get_tree().reload_current_scene()
