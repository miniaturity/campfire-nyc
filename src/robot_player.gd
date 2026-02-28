extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var body: Sprite2D = $Body
@onready var hand_1: Sprite2D = $Body/Hand1
@onready var hand_2: Sprite2D = $Body/Hand2
@onready var head: Sprite2D = $Body/Head

const SPEED = 100.0
const JUMP_VELOCITY = 300.0

var in_control: bool = false

func _ready() -> void:
	animation_player.play("floaty")

func _flip_based_on_direction(direction: float):
	if direction == 0:
		return
	if direction == 1:
		body.flip_h = true
		hand_1.flip_h = true
		hand_2.flip_h = true
		head.flip_h = true
	else:
		body.flip_h = false
		hand_1.flip_h = false
		hand_2.flip_h = false
		head.flip_h = false

func _unhandled_input(event: InputEvent) -> void:
	if not in_control:
		return
	
	if event.is_action_pressed("jump") and is_on_ceiling():
		velocity.y = JUMP_VELOCITY
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	_flip_based_on_direction(direction)

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_ceiling():
		velocity += -(get_gravity() * 0.9) * delta
	move_and_slide()
