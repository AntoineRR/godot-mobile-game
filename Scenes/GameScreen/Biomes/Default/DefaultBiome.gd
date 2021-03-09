class_name DefaultBiome

### Infos about one biome area

# Area size in tiles
var area_size = Vector2(12, 15)

### Tiles infos

# Probability arrays
# Those arrays define the probability of each tile appearing
# The probability are given in 1/1000 format
# [0] -> tile id, [1] -> probability
var walls = [
	Biome.Tile.new(0, preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall1.tscn"), 0),
	Biome.Tile.new(1, preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall2.tscn"), 1000)
]
var obstacles = [
	Biome.Tile.new(2, preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle1.tscn"), 10),
	Biome.Tile.new(3, preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle2.tscn"), 20)
]

var tiles = walls + obstacles

### Entities infos

# Enemies that can spawn
var enemies = [
	Biome.Enemy.new(preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn"), 10, Vector2(1,1))
]

# Coins that can spawn
var coins = [
	Biome.Coin.new(preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn"), 10)
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
	for i in range(area_size.y):
		# Left wall
		_add_tile(tilemap, -1, area_size.y * area_number + i, 0)
		_add_tile(tilemap, 0, area_size.y * area_number + i, _get_id_from_tiles(walls))
		# Right wall
		_add_tile(tilemap, area_size.x - 1, area_size.y * area_number + i, 0, true)
		_add_tile(tilemap, area_size.x - 2, area_size.y * area_number + i, _get_id_from_tiles(walls), true)

# Generate the obstacles tiles
func _spawn_obstacles(tilemap, area_number):
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			var id = _get_id_from_tiles(obstacles)
			if id != -1:
				_add_tile(tilemap, i, j, id)

# Add the tile to the scene and to loaded_tiles
func _add_tile(tilemap, x, y, id, flip_x=false):
	# Set cell in tilemap
	tilemap.set_cell(x, y, 0)
	# Spawn tile scene
	var position = tilemap.map_to_world(Vector2(x,y))
	var tile = tiles[id].resource.instance()
	tile.position = position + tilemap.cell_size/2
	if flip_x:
		tile.rotation = Vector2(-1,0).angle()
	tilemap.add_child(tile)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles.append(tile)

# Return a tile id using a given probability array
func _get_id_from_tiles(subtiles) -> int:
	var random = randi() % 1000
	var cumulative_prob = 0
	for elt in subtiles:
		cumulative_prob += elt.probability
		if random < cumulative_prob:
			return elt.id
	return -1
