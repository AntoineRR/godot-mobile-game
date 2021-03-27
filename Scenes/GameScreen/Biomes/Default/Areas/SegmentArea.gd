extends Node

class_name SegmentArea

enum CellType {
	GROUND = 0,
}

const CELL_MAP = {
	CellType.GROUND: {
		"probability": 1.0,
	}
}

var tilemap # Global tilemap
var area_tilemap # Tilemap containing the area data
var size
var y_top_cells

var loaded_tiles = [] # Tiles that are instanced
var loaded_enemies = [] # Enemies that are instanced
var loaded_coins = [] # Coins that are instanced

func _init(tilemap_, area_tilemap_, y_top_cells_):
	tilemap = tilemap_
	area_tilemap = area_tilemap_
	y_top_cells = y_top_cells_
	size = calculate_y_size()

func calculate_y_size() -> int:
	var y_size = 0
	for cell_pos in area_tilemap.get_used_cells():
		if cell_pos.y > y_size:
			y_size = cell_pos.y
	return y_size + 1

func spawn():
	for cell_pos in area_tilemap.get_used_cells():
		if area_tilemap.get_cellv(cell_pos) == CellType.GROUND:
			var pos = Vector2(cell_pos.x, cell_pos.y + y_top_cells)
			tilemap.set_cellv(pos, CellType.GROUND)
			loaded_tiles.append(pos)
	tilemap.update_bitmask_region()
	
	# TODO : spawn ennemies
	# TODO : spawn coins

func destroy():
	# Remove tiles
	for cell_pos in loaded_tiles:
		tilemap.set_cellv(cell_pos, -1)
	# Remove enemies
	for elt in loaded_enemies:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Remove coins
	for elt in loaded_coins:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
