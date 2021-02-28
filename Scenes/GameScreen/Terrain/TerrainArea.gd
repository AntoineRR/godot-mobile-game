extends Node

class_name TerrainArea

var tilemap
var biome
var area_number
var area_size

var loaded_tiles = [] # Tiels that are instanced
var loaded_enemies = [] # Enemies that are instanced
var loaded_money = [] # Coins that are instanced

func _init(tilemap_, area_number_, biome_):
	tilemap = tilemap_
	area_number = area_number_
	biome = GameManager.biomes[biome_]
	area_size = biome.area_size

func spawn():
	loaded_tiles = biome.spawn_tiles(tilemap, area_number)
	var enemies_diff = biome.max_enemies_in_area - biome.min_enemies_in_area
	var n_enemies = randi() % enemies_diff + biome.min_enemies_in_area
	spawn_enemies(n_enemies)
	var coins_diff = biome.max_coins_in_area - biome.min_coins_in_area
	var n_coins = randi() % coins_diff + biome.min_coins_in_area
	spawn_coins(n_coins)

func spawn_enemies(n):
	for _i in range(n):
		var x = (randi() % int(area_size.x)) * tilemap.cell_size.x
		var y = (randi() % int(area_size.y) + area_size.y * area_number) * tilemap.cell_size.y
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(area_size.x)) * tilemap.cell_size.x
			y = (randi() % int(area_size.y) + area_size.y * area_number) * tilemap.cell_size.y
		
		var enemy_index = randi() % biome.enemy_scenes.size()
		var enemy = biome.enemy_scenes[enemy_index].instance()
		tilemap.get_parent().call_deferred("add_child",enemy)
		
		enemy.position.x = x
		enemy.position.y = y
		enemy.z_index = 2
		
		loaded_enemies.append(enemy)

func spawn_coins(n):
	for _i in range(n):
		var x = (randi() % int(area_size.x)) * tilemap.cell_size.x
		var y = (randi() % int(area_size.y) + area_size.y * area_number) * tilemap.cell_size.y
		while tilemap.get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(area_size.x)) * tilemap.cell_size.x
			y = (randi() % int(area_size.y) + area_size.y * area_number) * tilemap.cell_size.y
		
		var coin_index = randi() % biome.coin_scenes.size()
		var coin = biome.coin_scenes[coin_index].instance()
		tilemap.get_parent().call_deferred("add_child",coin)
		
		coin.position.x = x
		coin.position.y = y
		coin.z_index = 2
		loaded_money.append(coin)

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
