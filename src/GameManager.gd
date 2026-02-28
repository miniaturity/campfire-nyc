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

# TODO: create the tilemaps
# NOTE: These will error if they are not properly named.
@onready var starvia_tile_map: TileMapLayer = get_tree().current_scene.get_node("StarviaTileMapLayer")
@onready var robot_tile_map: TileMapLayer = get_tree().current_scene.get_node("RobotTileMapLayer")

# NOTE: These will error if they are not properly named.
@onready var starvia_player: CharacterBody2D = get_tree().current_scene.get_node("StarviaPlayer")
@onready var robot_player: CharacterBody2D = get_tree().current_scene.get_node("RobotPlayer")

# Should teleport them back to start positions.
func kill():
	var starvia_coords = starvia_tile_map.to_global(
		get_first_tile_of_type(starvia_tile_map, "TileType", TILE_TYPES.START_POS)
	)
	
	if !starvia_coords:
		printerr("StartPos for Starvia not found.")
		pass
	
	var robot_coords = robot_tile_map.to_global(
		get_first_tile_of_type(robot_tile_map, "TileType", TILE_TYPES.START_POS)
	)
	
	if !robot_coords:
		printerr("StartPos for Robot not found.")
		pass
		
		starvia_player.global_position = starvia_coords
		robot_player.global_position = robot_coords
		
		print("Starvia STARTPOS Coords: " + "(" + starvia_coords.x + "," + starvia_coords.y + ")")
		print("Robot STARTPOS Coords: " + "(" + robot_coords.x + "," + robot_coords.y + ")")
	
	
	
	
	

func set_to_tile(map: TileMapLayer, player: CharacterBody2D, coords: Vector2i):
	var local_pos = map.map_to_local(coords)
	player.global_position = map.to_global(local_pos)

# Now returns tilemap coordinates
func get_first_tile_of_type(map: TileMapLayer, property_name: String, expected_data):
	var used_cells = map.get_used_cells()
	
	for coords in used_cells:
		var tile_data: TileData = map.get_cell_tile_data(coords)
		
		if tile_data:
			var custom_data = tile_data.get_custom_data(property_name)
			if custom_data == expected_data:
				return map.map_to_local(coords)
	
	printerr("Tile of property [" + property_name + "] not found!")
	return null
	
