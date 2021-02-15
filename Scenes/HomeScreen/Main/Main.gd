extends Node

# Variables
export(PackedScene) var game_scene

func _on_Button_pressed():
	GameManager.change_scene(GameManager.game_scene_path)
