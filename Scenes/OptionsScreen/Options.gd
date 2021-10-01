extends TextureButton


func _on_Main_Menu_pressed():
	GameManager.change_scene(GameManager.home_scene_path)
