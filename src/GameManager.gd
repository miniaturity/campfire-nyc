extends Node

# Global Variables

# NOTE: We need to manually set each tiles
# custom property ("TileType": int) to their respective
# types. 
enum TILE_TYPES {
	DEFAULT = 0,
	START_POS = 1,
	KILL = 2,
	BUTTON = 3,
	BUTTON_PLATFORM = 4
}

var current_level = 1

# TODO: create the tilemaps
# !! WARNING: These will error if they are not properly named.
@onready var starvia_tile_map: TileMapLayer = get_tree().current_scene.get_node("StarviaTileMapLayer")
@onready var robot_tile_map: TileMapLayer = get_tree().current_scene.get_node("RobotTileMapLayer")

# !! WARNING: These will error if they are not properly named.
@onready var starvia_player: CharacterBody2D = get_tree().current_scene.get_node("StarviaPlayer")
@onready var robot_player: CharacterBody2D = get_tree().current_scene.get_node("RobotPlayer")

@onready var starvia_spawn_point: Marker2D = get_tree().current_scene.get_node("StarviaSpawnPoint")
@onready var robot_spawn_point: Marker2D = get_tree().current_scene.get_node("RobotSpawnPoint")
# Button Tileset Textures

var button_tileset_source_id # TODO: Create button tileset

func _ready() -> void:
	kill()


# Should teleport them back to start positions.
func kill():
	starvia_player.global_position = starvia_spawn_point.global_position
	robot_player.global_position = robot_spawn_point.global_position
	
func process_collision(collision: KinematicCollision2D):
	if (collision.get_collider() is TileMapLayer):
		var map = collision.get_collider() as TileMapLayer
		var tile_pos = map.local_to_map(map.to_local(collision.get_position()))
		
		if map.get_cell_source_id(tile_pos) != -1:
			var tile_data = map.get_cell_tile_data(tile_pos)
			if tile_data:
				var button = tile_data.get_custom_data("button_id")
				if button:
					activate_button(map, button, tile_pos)
				 
	
func activate_button(map: TileMapLayer, button: int, button_pos: Vector2i):
	map.set_cell(button_pos, button_tileset_source_id, )
