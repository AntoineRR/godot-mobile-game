extends TileMap

### Exports ###

export(Array, PackedScene) var enemies_scenes
export(Array, PackedScene) var money

### Variables ###

var current_area = -1 # Area number
var tiles = [] # Tiles to choose from to build an area
var loaded_tiles = [] # Tiles that are instanced
var loaded_enemies = [] # Enemies that are instanced
var loaded_money = [] # Coins that are instanced
var n_areas_to_load = 0
var area_y_size = cell_size.y * GameManager.area_size.y

### Overriden methods ###

func _ready():
	tiles = tile_set.get_tiles_ids()
	n_areas_to_load = get_viewport_rect().size.y / area_y_size + 2
	current_area = -int(n_areas_to_load/2) - 1
	for _i in range(n_areas_to_load):
		loaded_tiles.append([])
		loaded_enemies.append([])
		loaded_money.append([])
		generate_next_area()

func _process(_delta):
	var player_y_pos = get_node("../Player").position.y
	if player_y_pos >= area_y_size * (current_area - 1):
		destroy_previous_area()
		add_enemies()
		add_coins()
		generate_next_area()

### Custom methods ###

# Generates tiles in an area
func generate_next_area():
	# Set walls to the left and right of the area
	for j in range(GameManager.area_size.y):
		add_tile(-1, GameManager.area_size.y * current_area + j, 0)
		add_tile(0, GameManager.area_size.y * current_area + j, 0)
		add_tile(GameManager.area_size.x - 1, GameManager.area_size.y * current_area + j, 0)
		add_tile(GameManager.area_size.x - 2, GameManager.area_size.y * current_area + j, 0)
	# Spawns 5 random objects in the area
	for _i in range(1):
		place_one_tile()
	current_area += 1

# Destroys the tiles in the top area
func destroy_previous_area():
	# Remove tiles in the top area
	for coords in loaded_tiles[0]:
		set_cell(coords.x, coords.y, -1)
	# Remove enemies in the top area
	for elt in loaded_enemies[0]:
		# If the object wasn't already destroyed
		if weakref(elt).get_ref():
			get_parent().call_deferred("remove_child",elt)
			elt.call_deferred("queue_free")
	# Shift loaded_tiles and loaded_enemies array
	for i in range(1, n_areas_to_load):
		loaded_tiles[i-1].clear()
		for elt in loaded_tiles[i]:
			loaded_tiles[i-1].append(elt)
		loaded_enemies[i-1].clear()
		for elt in loaded_enemies[i]:
			loaded_enemies[i-1].append(elt)
	loaded_tiles[n_areas_to_load - 1].clear()
	loaded_enemies[n_areas_to_load - 1].clear()

# Place a random tile at a random location inside the area
func place_one_tile():
	# Choose a random tile
	var tile = tiles[randi() % tiles.size()]
	# Choose a random unused location
	var x = randi() % int(GameManager.area_size.x)
	var y = randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area
	while get_used_cells().has(Vector2(x,y)):
		x = randi() % int(GameManager.area_size.x)
		y = randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area
	# Populate the cell at the chosen location with the chosen tile
	add_tile(x, y, tile)

# Add the tile to the scene and to loaded_tiles
func add_tile(x, y, id):
	# Set cell in tilemap
	set_cell(x, y, id)
	# Add tiles coordinates to the loaded tiles array
	loaded_tiles[loaded_tiles.size() - 1].append(Vector2(x,y))

# Add enemies to the area
func add_enemies():
	var n = randi() % 3
	for _i in range(n):
		var x = (randi() % int(GameManager.area_size.x)) * cell_size.x
		var y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area) * cell_size.y
		while get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(GameManager.area_size.x)) * cell_size.x
			y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area) * cell_size.y
		var enemy = enemies_scenes[0].instance()
		self.get_parent().add_child(enemy)
		enemy.position.x = x
		enemy.position.y = y
		loaded_enemies[loaded_enemies.size() - 1].append(enemy)
		
# Add enemies to the area
func add_coins():
	var n = randi() % 3
	for _i in range(n):
		var x = (randi() % int(GameManager.area_size.x)) * cell_size.x
		var y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area) * cell_size.y
		while get_used_cells().has(Vector2(x,y)):
			x = (randi() % int(GameManager.area_size.x)) * cell_size.x
			y = (randi() % int(GameManager.area_size.y) + GameManager.area_size.y * current_area) * cell_size.y
		var coin = money[0].instance()
		self.get_parent().add_child(coin)
		coin.position.x = x
		coin.position.y = y
		loaded_money[loaded_money.size() - 1].append(coin)
