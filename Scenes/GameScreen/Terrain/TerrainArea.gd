extends Node

class_name TerrainArea

var tilemap
var biome
var area_number
var area_size

var loaded_tiles = [] # Tiels that are instanced
var loaded_enemies = [] # Enemies that are instanced
var loaded_coins = [] # Coins that are instanced

func _init(tilemap_, area_number_, biome_):
	tilemap = tilemap_
	area_number = area_number_
	biome = biome_
	area_size = biome.area_size

func spawn(empty=false):
	loaded_tiles = biome.spawn_tiles(tilemap, area_number, empty)
	if not empty:
		loaded_enemies = biome.spawn_enemies(tilemap, area_number)
		loaded_coins = biome.spawn_coins(tilemap, area_number)

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
	for elt in loaded_coins:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			tilemap.set_cellv(tilemap.world_to_map(elt.position), -1)
			tilemap.get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Destroy area
	self.call_deferred("queue_free")
