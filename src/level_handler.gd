extends Node2D

@export var next_scene: PackedScene

@export var robot: CharacterBody2D
@export var starvia: CharacterBody2D

var dirty: bool = false
var can_switch: bool = true
var goal_number: int

func _ready() -> void:
	if not next_scene:
		push_warning("No next scene assigned!")
	
	if not starvia:
		starvia = get_tree().current_scene.get_node("StarviaPlayer")
	if not robot:
		robot = get_tree().current_scene.get_node("RobotPlayer")
	
	if not starvia or not robot:
		push_error("Cannot find player objs!")
		dirty = true
		return
	
	starvia.goal_reached.connect(starvia_reached_goal)
	robot.goal_reached.connect(robot_reached_goal)
	
	self.modulate = Color(0,0,0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1), 1)
	tween.play()

func check_if_level_complete():
	if goal_number < 2:
		return
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0,0,0), 1)
	tween.play()
	await tween.finished
	dirty = true
	if not next_scene: return
	get_tree().change_scene_to_packed(next_scene)

func starvia_reached_goal():
	can_switch = false
	if robot: pass_control(robot)
	goal_number += 1
	check_if_level_complete()

func robot_reached_goal():
	can_switch = false
	if starvia: pass_control(starvia)
	goal_number += 1
	check_if_level_complete()

func pass_control(character: CharacterBody2D):
	robot.in_control = false
	starvia.in_control = false
	character.in_control = true

func _unhandled_input(event: InputEvent) -> void:
	if dirty: return
	if not can_switch: return
	if not event.is_action_pressed("switch_controls"): return
	robot.in_control = not robot.in_control
	starvia.in_control = not starvia.in_control
