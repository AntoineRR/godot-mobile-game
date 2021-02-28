class_name DefaultBiome

# Area size in tiles
var area_size = Vector2(12, 15)

var min_obstacles_in_area = 0
var max_obstacles_in_area = 3

var min_enemies_in_area = 1
var max_enemies_in_area = 3

var min_coins_in_area = 2
var max_coins_in_area = 5

# Tiles infos

var tiles = preload("res://Scenes/GameScreen/Biomes/DefaultBiomeTileSet.tres").get_tiles_ids()

var complete_wall = 0
var walls_range = [1,2]
var obstacles_range = [3,4]

var enemy_scenes = [
	preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn")
]

var coin_scenes = [
	preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn")
]

var loaded_tiles = []

func spawn_tiles(tilemap, area_number) -> Array:
	loaded_tiles = []
	spawn_walls(tilemap, area_number)
	var obstacles_diff = max_obstacles_in_area - min_obstacles_in_area
	var n_obstacles = randi() % obstacles_diff + min_obstacles_in_area
	spawn_obstacles(tilemap, area_number, n_obstacles)
	return loaded_tiles

func spawn_walls(tilemap, area_number):
	for i in range(area_size.y):
		# Left wall
		add_tile(tilemap, -1, area_size.y * area_number + i, 0)
		add_tile(tilemap, 0, area_size.y * area_number + i, 0)
		# Right wall
		add_tile(tilemap, area_size.x - 1, area_size.y * area_number + i, 0)
		add_tile(tilemap, area_size.x - 2, area_size.y * area_number + i, 0)

func spawn_obstacles(tilemap, area_number, n):
	for _i in range(n):
		# Choose a random tile
		var tile = tiles[randi() % tiles.size()]
		# Choose a random unused location
		var x = randi() % (int(area_size.x) - 2) + 1
		var y = randi() % int(area_size.y) + area_size.y * area_number
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = randi() % (int(area_size.x) - 2) + 1
			y = randi() % int(area_size.y) + area_size.y * area_number
		# Populate the cell at the chosen location with the chosen tile
		add_tile(tilemap, x, y, tile)

# Add the tile to the scene and to loaded_tiles
func add_tile(tilemap, x, y, id):
	# Set cell in tilemap
	tilemap.set_cell(x, y, id)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles.append(Vector2(x,y))
