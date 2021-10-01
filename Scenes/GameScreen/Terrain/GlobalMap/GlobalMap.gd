extends Node2D

var areas

var first_area_lowest_point = 0 # y position of the lowest element of the top loaded area
var last_area_lowest_point = 0 # y position of the lowest element of the bottom loaded area

var segmentAreas = []

### Overriden methods ###

func _ready():
	GameManager.biome = GameManager.biomes[randi() % GameManager.biomes.size()]
	areas = GameManager.biome.Areas.instance()
	first_area_lowest_point = -get_viewport().size.y - 100
	last_area_lowest_point = first_area_lowest_point
	generate_next_area(true)
	first_area_lowest_point = last_area_lowest_point
	while last_area_lowest_point < get_viewport().size.y + 100:
		generate_next_area(true)

func generate_next_area(empty=false):
	# Get the level node
	var level_areas = areas.get_child(GameManager.level)
	# Get the sub level node
	var sub_level_areas = level_areas.get_child(GameManager.sub_level)
	# Get a random area inside the sub level
	var area_index = 0
	if not empty:
		area_index = randi() % sub_level_areas.get_child_count()
	var area_map = sub_level_areas.get_child(area_index)
	var area = SegmentArea.new(self, area_map, last_area_lowest_point)
	area.spawn()
	last_area_lowest_point += area.size
	segmentAreas.append(area)

func _process(_delta):
	var camera_y_pos = get_node("../Player/Camera2D").position.y + get_node("../Player").position.y
	if camera_y_pos + (get_viewport().size.y / 2) + 100 > last_area_lowest_point:
		generate_next_area()
	if camera_y_pos - (get_viewport().size.y / 2) - 100 > first_area_lowest_point:
		destroy_upper_area()

# Destroys the top area
func destroy_upper_area():
	first_area_lowest_point = segmentAreas[1].y_top_cells + segmentAreas[1].size
	var to_destroy = segmentAreas[0]
	to_destroy.destroy()
	segmentAreas.remove(0)
