extends Node

func _on_Home_pressed():
	GameManager.change_scene(GameManager.home_scene_path)

func _on_Start_pressed():
	GameManager.change_scene(GameManager.game_scene_path)
