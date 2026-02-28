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

# Restarts scene
func kill():
	print("Killed")
	get_tree().reload_current_scene()
