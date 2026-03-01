class_name BoxTeleporter
extends Node2D

## The other teleporter which the box teleports to.
@export var other: BoxTeleporter
## Whether the box can only go through one time
@export var oneWay: bool = true
## Whether it should invert gravity upon 
@export var changeGravity: bool = false
var teleported: bool = false

func _ready() -> void:
	if !other:
		push_error("BoxTeleporter is not connected to another BoxTeleporter")
		return

func _on_area_2d_body_entered(body: Node2D) -> void:
	var is_box = body is Box || body is ReverseGravityBox
	if is_box && !((oneWay || other.oneWay) && teleported):
		body.teleporting = !body.teleporting
		if body.teleporting:
			print('teleporting')
			if body is Box:
				print("Instantiating reverse gravity")
				var newBox = GameManager.ReverseGravityBoxScene.instantiate()
				call_deferred("add_child_to_root", newBox)
				newBox.set_deferred("global_position", other.global_position)
			else:
				print("Instantiating regular box")
				var newBox = GameManager.BoxScene.instantiate()
				call_deferred("add_child_to_root", newBox)
				newBox.set_deferred("global_position", other.global_position)
			teleported = true
			other.teleported = true
			body.queue_free()
		
func add_child_to_root(asd: Node2D):
	get_tree().root.add_child(asd)
