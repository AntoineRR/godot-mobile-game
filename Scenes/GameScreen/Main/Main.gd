extends Node

func end_game():
	GameManager.save_game()
	GameManager.change_scene(GameManager.home_scene_path)

func _on_Pause_pressed():
	get_tree().paused = true
	get_node("GUI/Popup").show()


func _on_Resume_pressed():
	get_tree().paused = false
	get_node("GUI/Popup").hide()


func _on_Home_pressed():
	get_tree().paused = false
	GameManager.change_scene(GameManager.home_scene_path)
