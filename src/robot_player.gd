extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var in_control: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not in_control:
		return
	
	if event.is_action_pressed("ui_accept") and is_on_ceiling():
		velocity.y = JUMP_VELOCITY
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_ceiling():
		velocity += -get_gravity() * delta
	move_and_slide()
