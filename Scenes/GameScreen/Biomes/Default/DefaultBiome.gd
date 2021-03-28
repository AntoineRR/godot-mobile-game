class_name DefaultBiome

### Infos about one biome area

var Areas = preload("res://Scenes/GameScreen/Biomes/Default/Areas/Areas.tscn")
var tileset_path = "res://Scenes/GameScreen/Biomes/Default/Default.tres"

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
	var monster_speed = 300
	var n_seconds_player_safe = 4
	var projectile_reload_time = 5
	var player_y_acceleration = 0.01
	var player_max_speed = 700

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
	var monster_speed = 500
	var n_seconds_player_safe = 3
	var projectile_reload_time = 3
	var player_y_acceleration = 0.015
	var player_max_speed = 850

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
	var monster_speed = 700
	var n_seconds_player_safe = 3
	var projectile_reload_time = 2
	var player_y_acceleration = 0.02
	var player_max_speed = 1000

var levels = [
	Level1.new(),
	Level2.new(),
	Level3.new()
]

func get_level():
	return levels[GameManager.level]
