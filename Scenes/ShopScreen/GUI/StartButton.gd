extends Button

onready var main_scene = get_tree().get_root().find_node("ShopMain", true, false)

func _ready():
	var _err = connect("pressed", main_scene, "_on_Start_pressed")
