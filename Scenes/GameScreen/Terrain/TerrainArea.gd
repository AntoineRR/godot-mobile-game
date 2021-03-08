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
	spawn_enemies()
	spawn_coins()

func spawn_enemies():
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			if Vector2(i,j) in tilemap.get_used_cells():
				continue
			
			var enemy_id = get_elt_id(biome.enemies)
			if enemy_id == -1:
				continue
			
			tilemap.set_cell(i, j, 0)
			
			var enemy = biome.enemies[enemy_id].resource.instance()
			tilemap.get_parent().call_deferred("add_child",enemy)

			var extents = enemy.get_node("CollisionShape2D").shape.extents * enemy.scale
			enemy.position = tilemap.map_to_world(Vector2(i,j)) + extents + tilemap.position
			enemy.z_index = 2

			loaded_enemies.append(enemy)

func spawn_coins():
	for i in range(1, area_size.x-2):
		for j in range(area_size.y * area_number, area_size.y * (area_number + 1)):
			if Vector2(i,j) in tilemap.get_used_cells():
				continue
			
			var coin_id = get_elt_id(biome.coins)
			if coin_id == -1:
				continue
			
			tilemap.set_cell(i, j, 0)
			
			var coin = biome.coins[coin_id].resource.instance()
			tilemap.get_parent().call_deferred("add_child",coin)

			var shape = coin.get_node("CollisionShape2D").shape
			var extents = Vector2(shape.radius*2 * coin.scale.x, shape.height * coin.scale.y)
			coin.position = tilemap.map_to_world(Vector2(i,j)) + extents + tilemap.position
			coin.z_index = 2

			loaded_money.append(coin)

func get_elt_id(elt_array) -> int:
	var random = randi() % 1000
	var cumulative_prob = 0
	for i in range(elt_array.size()):
		var elt = elt_array[i]
		cumulative_prob += elt.probability
		if random < cumulative_prob:
			return i
	return -1

func destroy():
	# Remove tiles
	for tile in loaded_tiles:
		if weakref(tile).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(tile.position), -1)
			tilemap.call_deferred("remove_child",tile)
			tile.call_deferred("queue_free")
	# Remove enemies
	for elt in loaded_enemies:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Remove coins
	for elt in loaded_money:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
