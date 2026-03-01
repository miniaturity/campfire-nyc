extends Control

@onready var top_half: ColorRect = $TopHalf
@onready var bottom_half: ColorRect = $BottomHalf

var starvia: CharacterBody2D
var robot: CharacterBody2D

var tracking: CharacterBody2D

func _ready():
	_make_disappear(top_half)
	_make_disappear(bottom_half)
	
	starvia = get_tree().current_scene.get_node("StarviaPlayer")
	robot = get_tree().current_scene.get_node("RobotPlayer")
	
	if not starvia or not robot:
		push_error("Could not find Starvia or Robot player objs (why am I here)")
		queue_free()
		return

func _make_disappear(target: ColorRect):
	var tween = create_tween()
	tween.tween_property(target, "modulate", Color(1,1,1,0), 0.5)

func _make_appear(target: ColorRect):
	var tween = create_tween()
	tween.tween_property(target, "modulate", Color(1,1,1,1), 0.5)

func _process(_delta: float) -> void:
	if not starvia or not robot:
		return
	
	if starvia.in_control and starvia != tracking:
		tracking = starvia
		_make_disappear(top_half)
		_make_appear(bottom_half)
	if robot.in_control and robot != tracking:
		tracking = robot
		_make_disappear(bottom_half)
		_make_appear(top_half)
