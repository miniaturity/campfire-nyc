# I meant to call this "control_switcher" but I mistyped and now its "control_switchet"
# let's keep it like that
extends Node

func disable():
	var player = get_tree().current_scene.get_node("StarviaPlayer")
	var robot = get_tree().current_scene.get_node("RobotPlayer")
	player.in_control = !player.in_control
	robot.in_control = !robot.in_control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("switch_controls"):
		get_viewport().set_input_as_handled()
		
		var player = get_tree().current_scene.get_node("StarviaPlayer")
		var robot = get_tree().current_scene.get_node("RobotPlayer")
		
		player.goal_reached.connect(disable)
		robot.goal_reached.connect(disable)
		
		if not player or not robot:
			push_error("Cannot find Player obj or Robot obj! They need to be top level objects in the scene!")
			return
		
		player.in_control = !player.in_control
		robot.in_control = !robot.in_control
		
		if robot.in_control:
			robot.play_wake_anim()
		else:
			robot.play_sleep_anim()
