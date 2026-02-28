extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_controls"):
		get_viewport().set_input_as_handled()
		var player = get_node("%Player")
		var robot = get_node("%Robot")
		
		if not player or not robot:
			push_error("Cannot find Player obj or Robot obj! Do they have unique names in this scene?")
		
		player.in_control = !player.in_control
		robot.in_control = !robot.in_control
