extends Camera2D

var starvia: CharacterBody2D
var robot: CharacterBody2D

var tracking: CharacterBody2D

func _ready() -> void:
	starvia = get_tree().current_scene.get_node("StarviaPlayer")
	robot = get_tree().current_scene.get_node("RobotPlayer")
	
	if not starvia or not robot:
		push_error("Could not find Starvia or Robot player objs (why am I here)")
		queue_free()
		return

func _physics_process(_delta: float) -> void:
	if not starvia or not robot:
		return
	
	if starvia.in_control and starvia != tracking:
		tracking = starvia
		reparent(starvia, false)
	if robot.in_control and robot != tracking:
		tracking = robot
		reparent(robot, false)
