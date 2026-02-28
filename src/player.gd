extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_COYOTE_FRAMES = 7
const JUMP_BUFFER_TIMEOUT = 5

var in_control: bool = true
var coyote_frames: int = MAX_COYOTE_FRAMES
var jump_buffer = 0

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
	move_and_slide()
	check_tile_collision_data()
	
func check_tile_collision_data():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMapLayer:
			var c_point = collision.get_position()
			var local_point = GameManager.starvia_tile_map.to_local(c_point)
			var t_coords = GameManager.starvia_tile_map.local_to_map(local_point)
			var t_data = GameManager.starvia_tile_map.get_cell_tile_data(t_coords)

			if t_data != null:
				match (t_data.get_custom_data("TileType")):
					null:
						pass
					2:
						GameManager.kill()
						pass
					_:
						pass
			
