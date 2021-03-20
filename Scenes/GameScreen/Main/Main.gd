extends Node

export(PackedScene) var splash_text;

onready var player = get_node("Player")
onready var monster = get_node("Monster")

func _ready():
	load_level()

# Game methods

func level_finished():
	if GameManager.level < 2:
		GameManager.start_of_level_position += GameManager.biome.get_level().size
		GameManager.level += 1
		load_level()
	else:
		end_game()

func load_level():
	# Splash screen indicating level number
	var label = splash_text.instance()
	get_node("GUI").add_child(label)
	label.set_msg("Level "+str(GameManager.level + 1))
	# Set the level parameters
	player.update_parameters()
	

func end_game():
	GameManager.level = 0
	GameManager.start_of_level_position = 0
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
