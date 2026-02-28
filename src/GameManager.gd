extends Node

# Global Variables

enum TILE_TYPES {
	DEFAULT = 0,
	START_POS = 1,
	KILL = 2,
}

# TODO: create the tilemaps
# NOTE: These will error if they are not properly named.
@onready var starvia_tile_map: TileMapLayer = get_tree().current_scene.get_node("StarviaTileMapLayer")
@onready var robot_tile_map: TileMapLayer = get_tree().current_scene.get_node("RobotTileMapLayer")

# NOTE: These will error if they are not properly named.
@onready var starvia_player: CharacterBody2D = get_tree().current_scene.get_node("StarviaPlayer")
@onready var robot_player: CharacterBody2D = get_tree().current_scene.get_node("RobotPlayer")

# TODO
func kill():
	var starvia_coords = starvia_tile_map.get_first_tile_of_type(starvia_tile_map, "TileType", TILE_TYPES.START_POS)
	
	
	
	

func set_to_tile(map: TileMapLayer, player: CharacterBody2D, coords: Vector2i):
	var local_pos = map.map_to_local(coords)
	player.global_position = map.to_global(local_pos)

func get_first_tile_of_type(map: TileMapLayer, property_name: String, expected_data):
	var used_cells = map.get_used_cells()
	
	for coords in used_cells:
		var tile_data: TileData = map.get_cell_tile_data(coords)
		
		if tile_data:
			var custom_data = tile_data.get_custom_data(property_name)
			if custom_data == expected_data:
				return tile_data
	
	printerr("Tile " + name + " not found!")
	return null
	
