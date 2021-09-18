extends Node

func _on_Start_pressed():
	GameManager.change_scene(GameManager.shop_scene_path)

func _on_Credits_Button_pressed():
	GameManager.change_scene(GameManager.credits_scene_path)


func _on_Options_pressed():
	GameManager.change_scene(GameManager.options_scene_path)
