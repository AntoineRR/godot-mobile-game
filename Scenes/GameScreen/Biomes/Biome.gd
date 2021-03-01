class_name Biome

class Tile:
	var id
	var probability
	
	func _init(id_, probability_):
		id = id_
		probability = probability_

class Enemy:
	var resource
	var probability
	var size
	
	func _init(resource_, probability_, size_):
		resource = resource_
		probability = probability_
		size = size_
