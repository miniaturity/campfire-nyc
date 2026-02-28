extends Area2D

func _on_body_entered(body):
	if body is CharacterBody2D:
		# TODO: Replace --NAME-- with tilemap name
		var tile_map = get_parent().get_node("--NAME--")
		
		if tile_map:
			var tile_coords = tile_map.local_to_map(global_position)
			var tile_data = tile_map.get_cell_tile_data(0, tile_coords)
			
			if tile_data:
				# NOTE: Name custom tile property "TileType"
				var tile_type = tile_data.get_custom_data("TileType")
				
				# Handle different tile types
				match tile_type:
					2:
						kill(body)
						pass
					_:
						pass
						


# TODO: Handle kill
func kill(_player: CharacterBody2D):
	pass
