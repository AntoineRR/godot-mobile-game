extends Node2D

onready var foregrounds = [get_child(0), get_child(1), get_child(2)]

func setup_foreground():
	var offset = GameManager.biome.get_level_size(0)
	foregrounds[0].position = Vector2(foregrounds[0].position.x, offset)
	offset += GameManager.biome.get_level_size(1)
	foregrounds[1].position = Vector2(foregrounds[1].position.x, offset)
	offset += GameManager.biome.get_level_size(2)
	foregrounds[2].position = Vector2(foregrounds[2].position.x, offset)
