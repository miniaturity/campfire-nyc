extends Node

# Global Variables

const ReverseGravityBoxScene: PackedScene = preload("res://objects/reverse_grav_box.tscn")
const BoxScene: PackedScene = preload("res://objects/box.tscn")

# NOTE: We need to manually set each tiles
# custom property ("TileType": int) to their respective
# types. 
enum TILE_TYPES {
	DEFAULT = 0,
	START_POS = 1, # Depreceated 
	KILL = 2,
}

var current_level = 1

var starvia_tile_map: TileMapLayer
var robot_tile_map: TileMapLayer

var starvia_player: CharacterBody2D
var robot_player: CharacterBody2D

## Levels in order
@export var levels: Array[PackedScene]
var currentLevel: int = 0

## Call this on level end
func on_level_end():
	if currentLevel == levels.size() - 1:
		on_all_levels_finished()
		return
	else:
		currentLevel += 1
		get_tree().change_scene_to_packed(levels[currentLevel])

## TODO: Special behavior for final level end
func on_all_levels_finished():
	pass

func register_level(starvia_map, robot_map, starvia_p, robot_p):
	starvia_tile_map = starvia_map
	robot_tile_map = robot_map
	starvia_player = starvia_p
	robot_player = robot_p
	

# Restarts scene
func kill():
	print("Killed")
		
	var scene_path = get_tree().current_scene.scene_file_path
	get_tree().call_deferred("change_scene_to_file", scene_path)
