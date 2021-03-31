extends Node

export(PackedScene) var splash_text;

onready var player = get_node("Player")
onready var monster = get_node("Monster")

func _ready():
	load_sub_level()

# Game methods

func sub_level_finished():
	if not GameManager.play_testing:
		if GameManager.sub_level < GameManager.biome.get_level().sub_level_size.size() - 1:
			GameManager.start_of_sub_level_position += GameManager.biome.get_sub_level_size()
			GameManager.sub_level += 1
			load_sub_level()
		else:
			level_finished()

func level_finished():
	if GameManager.level < GameManager.biome.levels.size() - 1:
		GameManager.start_of_sub_level_position += GameManager.biome.get_sub_level_size()
		GameManager.level += 1
		GameManager.sub_level = 0
		load_sub_level()
		# Set the level parameters
		player.update_parameters()
	else:
		end_game()

func load_sub_level():
	# Splash screen indicating level number
	var label = splash_text.instance()
	get_node("GUI").add_child(label)
	label.set_msg("Level "+str(GameManager.level + 1)+"."+str(GameManager.sub_level + 1))

func end_game():
	GameManager.level = 0
	GameManager.sub_level = 0
	GameManager.start_of_sub_level_position = 0
	GameManager.save_game()
	GameManager.change_scene(GameManager.shop_scene_path)

# UI methods

func _on_Pause_pressed():
	get_tree().paused = true
	get_node("GUI/Popup").show()

func _on_Resume_pressed():
	get_tree().paused = false
	get_node("GUI/Popup").hide()

func _on_Home_pressed():
	get_tree().paused = false
	GameManager.change_scene(GameManager.home_scene_path)
