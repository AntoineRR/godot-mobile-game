extends Node

# === Constants ===

# Scene paths
const home_scene_path = "res://Scenes/HomeScreen/Main/Main.tscn"
const game_scene_path = "res://Scenes/GameScreen/Main/Main.tscn"
const options_scene_path = "res://Scenes/OptionsScreen/Main/Main.tscn"
const credits_scene_path = "res://Scenes/CreditsScreen/Main/Main.tscn"

# Area size in tiles
# 2 areas loaded at once, the area the player is on and the next one
const area_size = Vector2(12, 10)

# === Node methods ===

func _ready():
	randomize()

# === Custom methods ===

func change_scene(new_scene_path):
	# Remove previous scene
	var root = get_tree().get_root()
	var current_scene = root.get_child(root.get_child_count() - 1)
	root.remove_child(current_scene)
	current_scene.call_deferred("free")

	# Add next scene
	var next_scene_resource = load(new_scene_path)
	var next_scene = next_scene_resource.instance()
	root.add_child(next_scene)
