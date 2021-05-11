extends Node2D

onready var backgrounds = [get_child(0), get_child(1), get_child(2), get_child(3)]

func setup_background():
	var offset = GameManager.biome.get_level_size(0)
	backgrounds[1].scroll_base_offset = Vector2(0, offset)
	offset += GameManager.biome.get_level_size(1)
	backgrounds[2].scroll_base_offset = Vector2(0, offset)
	offset += GameManager.biome.get_level_size(2)
	backgrounds[3].scroll_base_offset = Vector2(0, offset)
	for i in range(1, len(backgrounds)):
		remove_child(backgrounds[i])

func load_background():
	for i in range(0, get_child_count()):
		remove_child(get_child(i))
	add_child(backgrounds[GameManager.level])
	var sprite_height = backgrounds[GameManager.level].get_node("ParallaxLayer/Sprite").texture.get_height()
	var viewport_height = get_viewport().size.y
	var y_scale = (sprite_height - viewport_height) / float(GameManager.biome.get_level_size())
	get_child(0).get_child(0).motion_scale = Vector2(1.0, y_scale)
