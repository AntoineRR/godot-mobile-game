extends Node

class_name SegmentArea

var global_map: Node2D # Global Node
var area_map: Node2D # Node containing the area data
var size: float
var y_top_cells: float

var loaded_tiles = [] # Tiles that are instanced
var loaded_objects = [] # Objects (obstacles, ennemies, coins) that are instanced

func _init(new_global_map, new_area_map, new_y_top_cells):
	self.global_map = new_global_map
	self.area_map = new_area_map
	self.y_top_cells = new_y_top_cells
	size = calculate_y_size()

func calculate_y_size() -> float:
	return area_map.get_child(area_map.get_child_count() - 1).position.y

func spawn():
	# Spawn objects (obstacles, ennemies, coins)
	for object in area_map.get_children():
		var new_object = object.duplicate()
		new_object.position.y += y_top_cells
		global_map.add_child(new_object)
		loaded_objects.append(new_object)

func destroy():
	# Remove objects
	for elt in loaded_objects:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			global_map.call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
