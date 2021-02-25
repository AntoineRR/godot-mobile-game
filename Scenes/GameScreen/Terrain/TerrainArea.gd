extends Node

class_name TerrainArea

var tilemap
var biome
var area_number

var loaded_tiles = [] # Tiles that are instanced
var loaded_enemies = [] # Enemies that are instanced
var loaded_money = [] # Coins that are instanced

func _init(tilemap_, area_number_, biome_):
	tilemap = tilemap_
	area_number = area_number_
	biome = biome_

func spawn():
	spawn_walls()
	var obstacles_diff = GameManager.biomes[biome].max_obstacles_in_area - GameManager.biomes[biome].min_obstacles_in_area
	var n_obstacles = randi() % obstacles_diff + GameManager.biomes[biome].min_obstacles_in_area
	spawn_obstacles(n_obstacles)
	var enemies_diff = GameManager.biomes[biome].max_enemies_in_area - GameManager.biomes[biome].min_enemies_in_area
	var n_enemies = randi() % enemies_diff + GameManager.biomes[biome].min_enemies_in_area
	spawn_enemies(n_enemies)
	var coins_diff = GameManager.biomes[biome].max_coins_in_area - GameManager.biomes[biome].min_coins_in_area
	var n_coins = randi() % coins_diff + GameManager.biomes[biome].min_coins_in_area
	spawn_coins(n_coins)

func spawn_walls():
	for i in range(GameManager.area_size.y):
		# Left wall
		add_tile(-1, GameManager.area_size.y * area_number + i, 0)
		add_tile(0, GameManager.area_size.y * area_number + i, 0)
		# Right wall
		add_tile(GameManager.area_size.x - 1, GameManager.area_size.y * area_number + i, 0)
		add_tile(GameManager.area_size.x - 2, GameManager.area_size.y * area_number + i, 0)

func spawn_obstacles(n):
	for _i in range(n):
		# Choose a random tile
		var tile = tilemap.tiles[randi() % tilemap.tiles.size()]
		# Choose a random unused location
		var x = randi() % (int(GameManager.area_size.x) - 2) + 1
		var y = randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = randi() % (int(GameManager.area_size.x) - 2) + 1
			y = randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number
		# Populate the cell at the chosen location with the chosen tile
		add_tile(x, y, tile)

func spawn_enemies(n):
	for _i in range(n):
		var x = (randi() % int(GameManager.area_size.x)) * tilemap.cell_size.x
		var y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number) * tilemap.cell_size.y
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(GameManager.area_size.x)) * tilemap.cell_size.x
			y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number) * tilemap.cell_size.y
		
		var enemy_index = randi() % GameManager.biomes[biome].enemy_scenes.size()
		var enemy = GameManager.biomes[biome].enemy_scenes[enemy_index].instance()
		tilemap.get_parent().call_deferred("add_child",enemy)
		
		enemy.position.x = x
		enemy.position.y = y
		enemy.z_index = 2
		
		loaded_enemies.append(enemy)

func spawn_coins(n):
	for _i in range(n):
		var x = (randi() % int(GameManager.area_size.x)) * tilemap.cell_size.x
		var y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number) * tilemap.cell_size.y
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(GameManager.area_size.x)) * tilemap.cell_size.x
			y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * area_number) * tilemap.cell_size.y
		
		var coin_index = randi() % GameManager.biomes[biome].coin_scenes.size()
		var coin = GameManager.biomes[biome].coin_scenes[coin_index].instance()
		tilemap.get_parent().call_deferred("add_child",coin)
		
		coin.position.x = x
		coin.position.y = y
		coin.z_index = 2
		loaded_money.append(coin)

# Add the tile to the scene and to loaded_tiles
func add_tile(x, y, id):
	# Set cell in tilemap
	tilemap.set_cell(x, y, id)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles.append(Vector2(x,y))

func destroy():
	# Remove tiles
	for coords in loaded_tiles:
		tilemap.set_cell(coords.x, coords.y, -1)
	# Remove enemies
	for elt in loaded_enemies:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Remove coins
	for elt in loaded_money:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
