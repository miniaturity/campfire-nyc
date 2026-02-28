extends Node

# Global Variables

# NOTE: We need to manually set each tiles
# custom property ("TileType": int) to their respective
# types. 
enum TILE_TYPES {
	DEFAULT = 0,
	START_POS = 1,
	KILL = 2,
}

var current_level = 1

# TODO: create the tilemaps
# !! WARNING: These will error if they are not properly named.
@onready var starvia_tile_map: TileMapLayer = get_tree().current_scene.get_node("StarviaTileMapLayer")
@onready var robot_tile_map: TileMapLayer = get_tree().current_scene.get_node("RobotTileMapLayer")

# !! WARNING: These will error if they are not properly named.
@onready var starvia_player: CharacterBody2D = get_tree().current_scene.get_node("StarviaPlayer")
@onready var robot_player: CharacterBody2D = get_tree().current_scene.get_node("RobotPlayer")

@onready var spawn_point: CharacterBody2D = get_tree().current_scene.get_node("Spawnpoint")

# Should teleport them back to start positions.
func kill():
	starvia_player.global_position = spawn_point.global_position
	robot_player.global_position = spawn_point.global_position

func set_to_tile(map: TileMapLayer, player: CharacterBody2D, coords: Vector2i):
	var local_pos = map.map_to_local(coords)
	player.global_position = map.to_global(local_pos)
	
