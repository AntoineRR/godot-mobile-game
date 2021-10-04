extends CanvasLayer

func _process(_delta):
	$Label.text = str(Engine.get_frames_per_second()) + " fps"
