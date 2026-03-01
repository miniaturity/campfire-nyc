extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const MAX_COYOTE_FRAMES = 7
const JUMP_BUFFER_TIMEOUT = 5
const PUSH_FORCE = 100
const BLOCK_MAX_VELOCITY = 180

signal goal_reached

var in_control: bool = true
var coyote_frames: int = MAX_COYOTE_FRAMES
var jump_buffer = 0

var teleporting: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not in_control:
		return
	
	if event.is_action_pressed("jump") and (is_on_floor() or coyote_frames > 0):
		velocity.y = JUMP_VELOCITY
	elif event.is_action_pressed("jump") and not is_on_floor():
		jump_buffer = JUMP_BUFFER_TIMEOUT
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	if absf(position.y) >= 1000:
		get_tree().reload_current_scene()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_frames -= 1
		coyote_frames = clampi(coyote_frames, 0, 99)
	
	if is_on_floor() and coyote_frames != MAX_COYOTE_FRAMES:
		coyote_frames = MAX_COYOTE_FRAMES
	
	if is_on_floor() and jump_buffer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer = 0
	
	if jump_buffer > 0:
		jump_buffer -= 1
	
	if Input.get_axis("move_left", "move_right") == 0 or in_control == false:
		velocity.x = 0
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_block = collision.get_collider()
		if collision_block == null: continue
		if collision_block.is_in_group("Boxes") and abs(collision_block.get_linear_velocity().x) < BLOCK_MAX_VELOCITY:
			collision_block.apply_central_impulse(collision.get_normal() * -PUSH_FORCE)
	move_and_slide()

func reached_goal():
	goal_reached.emit()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1)
	tween.play()
	animated_sprite_2d.play()
	in_control = false
	await animated_sprite_2d.animation_finished
	queue_free()
