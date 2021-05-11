class_name DefaultBiome

### Infos about one biome area

var Areas = preload("res://Scenes/GameScreen/Biomes/Default/Areas/Areas.tscn")
var tileset_path = "res://Scenes/GameScreen/Biomes/Default/Default.tres"

### Levels infos

class Level1:
	## Level data
	var sub_level_size = [5000,5000,5000]
	var monster_speed = 300
	var n_seconds_player_safe = 4
	var projectile_reload_time = 5
	var player_y_acceleration = 0.01
	var player_max_speed = 700

class Level2:
	## Level data
	var sub_level_size = [5000,5000,5000]
	var monster_speed = 500
	var n_seconds_player_safe = 3
	var projectile_reload_time = 3
	var player_y_acceleration = 0.015
	var player_max_speed = 850

class Level3:
	## Level data
	var sub_level_size = [15000,15000,15000]
	var monster_speed = 700
	var n_seconds_player_safe = 3
	var projectile_reload_time = 2
	var player_y_acceleration = 0.02
	var player_max_speed = 1000

# Palier INSANE
class Level4:
	## Level data
	var sub_level_size = [15000,15000,15000]
	var monster_speed = 1200
	var n_seconds_player_safe = 3
	var projectile_reload_time = 0.5
	var player_y_acceleration = 0.04
	var player_max_speed = 1500

var levels = [
	Level1.new(),
	Level2.new(),
	Level3.new(),
	Level4.new()
]

func get_level():
	return levels[GameManager.level]

func get_level_size(var level = -1) -> int:
	if (level == -1):
		level = GameManager.level
	var result = 0
	for size in levels[level].sub_level_size:
		result += size
	return result

func get_sub_level_size() -> int:
	return levels[GameManager.level].sub_level_size[GameManager.sub_level]
