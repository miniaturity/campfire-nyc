extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var body: Sprite2D = $Body
@onready var hand_1: Sprite2D = $Body/Hand1
@onready var hand_2: Sprite2D = $Body/Hand2
@onready var head: Sprite2D = $Body/Head
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var goal_sfx: AudioStreamPlayer2D = $GoalSFX

const SPEED = 150.0
const JUMP_VELOCITY = 300.0
const MAX_COYOTE_FRAMES = 7
const JUMP_BUFFER_TIMEOUT = 5
const PUSH_FORCE = 100
const BLOCK_MAX_VELOCITY = 180

signal goal_reached

var in_control: bool = false
var coyote_frames: int = MAX_COYOTE_FRAMES
var jump_buffer = 0

var teleporting: bool = false

func _ready() -> void:
	animation_player.play(&"power_off")

func play_sleep_anim():
	animation_player.play(&"power_off")

func play_wake_anim():
	animation_player.play(&"power_off", -1, -1.0, true)
	await animation_player.animation_finished
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
	
	if event.is_action_pressed("jump") and (is_on_ceiling() or coyote_frames > 0):
		velocity.y = JUMP_VELOCITY
		coyote_frames = 0
		jump_sfx.play()
	elif event.is_action_pressed("jump") and not is_on_ceiling():
		jump_buffer = JUMP_BUFFER_TIMEOUT
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	_flip_based_on_direction(direction)

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	if absf(position.y) >= 1000:
		get_tree().reload_current_scene()
	
	# Add the gravity.
	if not is_on_ceiling():
		velocity += -(get_gravity() * 0.9) * delta
		coyote_frames -= 1
		coyote_frames = clamp(coyote_frames, 0, 99)
	if is_on_ceiling() and coyote_frames != MAX_COYOTE_FRAMES:
		coyote_frames = MAX_COYOTE_FRAMES
	
	if is_on_ceiling() and jump_buffer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer = 0
		jump_sfx.play()
	
	if jump_buffer > 0:
		jump_buffer -= 1
	
	if Input.get_axis("move_left", "move_right") == 0 or in_control == false:
		velocity.x = 0
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_block = collision.get_collider()
		if collision_block.is_in_group("Boxes") and abs(collision_block.get_linear_velocity().x) < BLOCK_MAX_VELOCITY:
			collision_block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
	
	move_and_slide()

func reached_goal():
	goal_sfx.play()
	goal_reached.emit()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
	tween.play()
	animated_sprite_2d.play()
	in_control = false
	await animated_sprite_2d.animation_finished
	queue_free()
