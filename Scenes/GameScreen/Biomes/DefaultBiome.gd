class_name DefaultBiome

### Infos about one biome area

# Area size in tiles
var area_size = Vector2(12, 15)

var min_enemies_in_area = 1
var max_enemies_in_area = 3

var min_coins_in_area = 2
var max_coins_in_area = 5

### Tiles infos

# Available tiles for this biome
var tiles = preload("res://Scenes/GameScreen/Biomes/DefaultBiomeTileSet.tres").get_tiles_ids()

# Probability arrays
# Those arrays define the probability of each tile appearing
# The probability are given in 1/1000 format
# [0] -> tile id, [1] -> probability
var walls = [ [0, 100], [1, 600], [2, 300] ]
var obstacles = [ [3, 0], [4, 20] ]

### Entities infos

# Enemies that can spawn
var enemy_scenes = [
	preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn")
]

# Coins that can spawn
var coin_scenes = [
	preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn")
]

### Tiles spawning methods

var loaded_tiles = []

# Called from terrainArea to spawn the tiles
func spawn_tiles(tilemap, area_number) -> Array:
	loaded_tiles = []
	_spawn_walls(tilemap, area_number)
	_spawn_obstacles(tilemap, area_number)
	return loaded_tiles

# Generate the walls tiles
func _spawn_walls(tilemap, area_number):
	var tile_id = 0
	for i in range(area_size.y):
		# Left wall
		_add_tile(tilemap, -1, area_size.y * area_number + i, 0)
		_add_tile(tilemap, 0, area_size.y * area_number + i, _get_id_from_probability_array(walls))
		# Right wall
		_add_tile(tilemap, area_size.x - 1, area_size.y * area_number + i, 0, true)
		_add_tile(tilemap, area_size.x - 2, area_size.y * area_number + i, _get_id_from_probability_array(walls), true)

# Generate the obstacles tiles
func _spawn_obstacles(tilemap, area_number):
	var flip_x = false
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			if tilemap.get_cell(i-1, j) == 0:
				_add_tile(tilemap, i, j, obstacles[0][0], false)
				continue
			elif tilemap.get_cell(i+1, j) == 0:
				_add_tile(tilemap, i, j, obstacles[0][0], true)
				continue
			
			var id = _get_id_from_probability_array(obstacles)
			if id != -1:
				_add_tile(tilemap, i, j, id)

# Add the tile to the scene and to loaded_tiles
func _add_tile(tilemap, x, y, id, flip_x=false):
	# Set cell in tilemap
	tilemap.set_cell(x, y, id, flip_x)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles.append(Vector2(x,y))

# Return a tile id using a given probability array
func _get_id_from_probability_array(p_array) -> int:
	var random = randi() % 1000
	var cumulative_prob = 0
	for elt in p_array:
		cumulative_prob += elt[1]
		if random < cumulative_prob:
			return elt[0]
	return -1
