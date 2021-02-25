extends TileMap

### Variables ###

var biome = 0

var current_area = -1 # Area number
var tiles = [] # Tiles to choose from to build an area
var n_areas_to_load = 0
var area_y_size = cell_size.y * GameManager.area_size.y

var terrainAreas = []

### Overriden methods ###

func _ready():
	biome = randi() % GameManager.biomes.size() # Choose biome randomly
	tiles = tile_set.get_tiles_ids()
	n_areas_to_load = get_viewport().size.y / area_y_size + 2
	current_area = -int(n_areas_to_load/2) - 1
	for _i in range(n_areas_to_load):
		generate_next_area()

func generate_next_area():
	var area = TerrainArea.new(self, current_area, biome)
	area.spawn()
	terrainAreas.append(area)
	current_area += 1

func _process(_delta):
	var player_y_pos = get_node("../Player").position.y
	if player_y_pos >= area_y_size * (current_area - 1):
		destroy_previous_area()
		generate_next_area()

### Custom methods ###

# Destroys the top area
func destroy_previous_area():
	var to_destroy = terrainAreas[0]
	to_destroy.destroy()
	terrainAreas.remove(0)
