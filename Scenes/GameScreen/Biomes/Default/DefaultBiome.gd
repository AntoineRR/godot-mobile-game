class_name DefaultBiome

### Infos about one biome area

# Area size in tiles
var area_size = Vector2(12, 15)

### Levels infos

class Level1:
	## Tiles infos
	var walls = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall1.tscn"), 0.0),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall2.tscn"), 1.0)
	]
	var obstacles = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle1.tscn"), 0.01),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle2.tscn"), 0.02)
	]
	
	## Entities infos
	var enemies = [
		Biome.Enemy.new(preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn"), 0.01, Vector2(1,1))
	]
	var coins = [
		Biome.Coin.new(preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn"), 0.01)
	]
	
	## Level data
	var size = 20000

class Level2:
	## Tiles infos
	var walls = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall1.tscn"), 0.0),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall2.tscn"), 1.0)
	]
	var obstacles = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle1.tscn"), 0.02),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle2.tscn"), 0.04)
	]
	
	## Entities infos
	var enemies = [
		Biome.Enemy.new(preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn"), 0.02, Vector2(1,1))
	]
	var coins = [
		Biome.Coin.new(preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn"), 0.005)
	]
	
	## Level data
	var size = 30000

class Level3:
	## Tiles infos
	var walls = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall1.tscn"), 0.0),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Wall2.tscn"), 1.0)
	]
	var obstacles = [
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle1.tscn"), 0.04),
		Biome.Tile.new(preload("res://Scenes/GameScreen/Biomes/Default/Tiles/Obstacle2.tscn"), 0.08)
	]
	
	## Entities infos
	var enemies = [
		Biome.Enemy.new(preload("res://Scenes/GameScreen/Enemies/Enemy1.tscn"), 0.04, Vector2(1,1))
	]
	var coins = [
		Biome.Coin.new(preload("res://Scenes/GameScreen/Bonus/Money/Money.tscn"), 0.001)
	]
	
	## Level data
	var size = 50000

var levels = [
	Level1.new(),
	Level2.new(),
	Level3.new()
]

### Tiles spawning methods

var loaded_tiles = []

# Called from terrainArea to spawn the tiles
func spawn_tiles(tilemap, area_number, empty=false) -> Array:
	loaded_tiles = []
	_spawn_walls(tilemap, area_number)
	if not empty:
		_spawn_obstacles(tilemap, area_number)
	return loaded_tiles

# Generate the walls tiles
func _spawn_walls(tilemap, area_number):
	for i in range(area_size.y):
		# Left wall
		_add_tile(tilemap, get_level().walls, -1, area_size.y * area_number + i, 0)
		_add_tile(tilemap, get_level().walls, 0, area_size.y * area_number + i, _get_elt_id(get_level().walls))
		# Right wall
		_add_tile(tilemap, get_level().walls, area_size.x - 1, area_size.y * area_number + i, 0, true)
		_add_tile(tilemap, get_level().walls, area_size.x - 2, area_size.y * area_number + i, _get_elt_id(get_level().walls), true)

# Generate the obstacles tiles
func _spawn_obstacles(tilemap, area_number):
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			var id = _get_elt_id(get_level().obstacles)
			if id != -1:
				_add_tile(tilemap, get_level().obstacles, i, j, id)

# Add the tile to the scene and to loaded_tiles
func _add_tile(tilemap, subtiles, x, y, id, flip_x=false):
	# Set cell in tilemap
	tilemap.set_cell(x, y, 0)
	# Spawn tile scene
	var position = tilemap.map_to_world(Vector2(x,y))
	var tile = subtiles[id].resource.instance()
	tile.position = position + tilemap.cell_size/2
	if flip_x:
		tile.rotation = Vector2(-1,0).angle()
	tilemap.add_child(tile)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles.append(tile)

# Add enemies
func spawn_enemies(tilemap, area_number) -> Array:
	var loaded_enemies = []
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			if Vector2(i,j) in tilemap.get_used_cells():
				continue
			
			var enemy_id = _get_elt_id(get_level().enemies)
			if enemy_id == -1:
				continue
			
			tilemap.set_cell(i, j, 0)
			
			var enemy = get_level().enemies[enemy_id].resource.instance()
			tilemap.get_parent().call_deferred("add_child",enemy)

			var extents = enemy.get_node("CollisionShape2D").shape.extents * enemy.scale
			enemy.position = tilemap.map_to_world(Vector2(i,j)) + extents + tilemap.position
			enemy.z_index = 2

			loaded_enemies.append(enemy)
	
	return loaded_enemies

# Add collectable coins
func spawn_coins(tilemap, area_number) -> Array:
	var loaded_coins = []
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			if Vector2(i,j) in tilemap.get_used_cells():
				continue
			
			var coin_id = _get_elt_id(get_level().coins)
			if coin_id == -1:
				continue
			
			tilemap.set_cell(i, j, 0)
			
			var coin = get_level().coins[coin_id].resource.instance()
			tilemap.get_parent().call_deferred("add_child",coin)

			var shape = coin.get_node("CollisionShape2D").shape
			var extents = Vector2(shape.radius*2 * coin.scale.x, shape.height * coin.scale.y)
			coin.position = tilemap.map_to_world(Vector2(i,j)) + extents + tilemap.position
			coin.z_index = 2

			loaded_coins.append(coin)
	
	return loaded_coins

# Return a tile id using a given probability array
func _get_elt_id(elt_array) -> int:
	var random = randf()
	var cumulative_prob = 0
	for i in range(elt_array.size()):
		cumulative_prob += elt_array[i].probability
		if random < cumulative_prob:
			return i
	return -1

func get_level():
	return levels[GameManager.level]
