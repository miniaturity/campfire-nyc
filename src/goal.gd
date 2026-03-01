extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&"Players"):
		return
	
	body.reached_goal()
	queue_free()
