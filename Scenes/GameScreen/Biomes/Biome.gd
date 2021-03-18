class_name Biome

class Tile:
	var resource
	var probability
	
	func _init(resource_, probability_):
		resource = resource_
		probability = probability_

class Enemy:
	var resource
	var probability
	var size
	
	func _init(resource_, probability_, size_):
		resource = resource_
		probability = probability_
		size = size_

class Coin:
	var resource
	var probability
	
	func _init(resource_, probability_):
		resource = resource_
		probability = probability_
