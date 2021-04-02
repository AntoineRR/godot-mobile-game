extends TileMap

const CELL_SIZE = Vector2(48, 48)

var areas

var loaded_areas = []
var y_upper_cell = 0 # y position of the lowest cell of the top loaded area
var y_lower_cell = 0 # y position of the lowest cell of the bottom loaded area
var n_cell_on_screen_height = 0

var segmentAreas = []

### Overriden methods ###

func _ready():
	GameManager.biome = GameManager.biomes[randi() % GameManager.biomes.size()]
	self.tile_set = load(GameManager.biome.tileset_path)
	areas = GameManager.biome.Areas.instance()
	n_cell_on_screen_height = get_viewport().size.y / CELL_SIZE.y
	y_upper_cell = int(-(get_viewport().size.y - 100) / CELL_SIZE.y)
	y_lower_cell = y_upper_cell
	generate_next_area(true)
	y_upper_cell = y_lower_cell
	while y_lower_cell < n_cell_on_screen_height:
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
	var area_tilemap = sub_level_areas.get_child(area_index)
	var area = SegmentArea.new(self, area_tilemap, y_lower_cell)
	area.spawn()
	y_lower_cell += area.size
	segmentAreas.append(area)

func _process(_delta):
	var camera_y_pos = get_node("../Player/Camera2D").position.y + get_node("../Player").position.y
	if camera_y_pos + (get_viewport().size.y / 2) + 100 > y_lower_cell * CELL_SIZE.y:
		generate_next_area()
	if camera_y_pos - (get_viewport().size.y / 2) - 100 > y_upper_cell * CELL_SIZE.y:
		destroy_upper_area()

# Destroys the top area
func destroy_upper_area():
	y_upper_cell = segmentAreas[1].y_top_cells + segmentAreas[1].size
	var to_destroy = segmentAreas[0]
	to_destroy.destroy()
	segmentAreas.remove(0)
