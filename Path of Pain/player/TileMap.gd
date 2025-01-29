extends TileMap

var clicked_cell = local_to_map(Vector2(680,440))

var tile_data : TileData = get_cell_tile_data(0,clicked_cell)


#func _process(delta):
#
#	if tile_data:
#		print(tile_data.get_custom_data("spike"))
#		pass
		

