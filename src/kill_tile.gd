extends Area2D

func _on_body_entered(body):
  if body is CharacterBody2D:
    # !! REPLACE name with tilemap name.
    var tile_map = get_parent().get_node("--NAME--")

    if tile_map:
      var tile_coordinates = tile_map.local_to_map(global_position)
      var tile_data = tile_map.get_cell_tile_data(0, tile_coordinates)
      
      if tile_data:
        # Note: Name custom tile data "TileType".
        var tile_type = tile_data.get_custom_data("TileType")

        if tile_type == 1:
          # TODO: Handle death
          return
