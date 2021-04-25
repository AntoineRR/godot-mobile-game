extends Node

#######################
# GAME TEST VARIABLES #
#######################

const play_testing = true # Stick to a specific sub level
const play_test_level = 2 # Level to play between 1 and 4
const play_test_sub_level = 1 # Sub level to play between 1 and 3

#######################

### Constants ###

# Scene paths
const home_scene_path = "res://Scenes/HomeScreen/Main/Main.tscn"
const game_scene_path = "res://Scenes/GameScreen/Main/Main.tscn"
const shop_scene_path = "res://Scenes/ShopScreen/Main/Main.tscn"

# Save path
const save_path = "user://user.save"

### Variables ###

# Used for the back button
var current_screen = ""
var previous_screen = ""

# Biomes
var biomes = {
	0: DefaultBiome.new()
}

# Game variables
var biome
var level = 0
var sub_level = 0
var start_of_sub_level_position = 0

# Utilities
var os_name = OS.get_name()

# === Node methods ===

func _ready():
	current_screen = home_scene_path
	load_save()
	randomize()

# === Custom methods ===

func change_scene(new_scene_path):
	# Change variables
	previous_screen = current_screen
	current_screen = new_scene_path
	
	# Remove previous scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	root.call_deferred("remove_child",current_scene)
	current_scene.call_deferred("free")

	# Add next scene
	var next_scene_resource = load(new_scene_path)
	var next_scene = next_scene_resource.instance()
	root.add_child(next_scene)

func save_game():
	var nodes_to_save = get_tree().get_nodes_in_group("ToSave")
	var save_file = File.new()
	save_file.open_encrypted_with_pass(save_path, File.WRITE, OS.get_unique_id())
	for node in nodes_to_save:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(to_json(node_data))
	save_file.close()

func load_save():
	var save_file = File.new()
	if not save_file.file_exists(save_path):
		return

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_file.open_encrypted_with_pass(save_path, File.READ, OS.get_unique_id())
	while save_file.get_position() < save_file.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_file.get_line())

		# Now we set the remaining variables.
		for i in node_data.keys():
			UserData.set(i, node_data[i])

	save_file.close()







