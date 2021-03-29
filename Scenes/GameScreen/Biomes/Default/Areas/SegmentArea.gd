extends Node

class_name SegmentArea

enum CellType {
	GROUND = 0,
	GRASS = 1,
	MAYBE_GROUND = 2,
	MAYBE_GRASS = 3,
}

const CELL_MAP = {
	CellType.GROUND: {
		"probability": 1.0,
		"cell": CellType.GROUND,
	},
	CellType.GRASS: {
		"probability": 1.0,
		"cell": CellType.GRASS,
	},
	CellType.MAYBE_GROUND: {
		"probability": 0.5,
		"cell": CellType.GROUND,
	},
	CellType.MAYBE_GRASS: {
		"probability": 0.5,
		"cell": CellType.GRASS,
	}
}

var tilemap # Global tilemap
var area_tilemap # Tilemap containing the area data
var size
var y_top_cells

var loaded_tiles = [] # Tiles that are instanced
var loaded_objects = [] # Objects (obstacles, ennemies, coins) that are instanced

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
	# Spawn tiles
	var used_cells = area_tilemap.get_used_cells()
	var area_start = Vector2(used_cells[0].x, used_cells[0].y + y_top_cells)
	var area_end = Vector2(used_cells[used_cells.size()-1].x, used_cells[used_cells.size()-1].y + y_top_cells)
	for cell_pos in used_cells:
		var cell_type = area_tilemap.get_cellv(cell_pos)
		if randf() < CELL_MAP[cell_type].probability:
			var pos = Vector2(cell_pos.x, cell_pos.y + y_top_cells)
			tilemap.set_cellv(pos, CELL_MAP[cell_type].cell)
			loaded_tiles.append(pos)
	tilemap.update_bitmask_region(area_start, area_end)
	
	# Spawn objects (obstacles, ennemies, coins)
	for object in area_tilemap.get_children():
		var new_object = object.duplicate()
		new_object.position.y += y_top_cells * tilemap.CELL_SIZE.y
		tilemap.add_child(new_object)
		loaded_objects.append(new_object)

func destroy():
	# Remove tiles
	for cell_pos in loaded_tiles:
		tilemap.set_cellv(cell_pos, -1)
	# Remove objects
	for elt in loaded_objects:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
