extends AnimatedSprite

func _process(_delta):
	var player = get_node("../Player")
	var current_height = frames.get_frame(animation, frame).get_size().y
	var offset = (GameManager.max_player_health - player.player_health) * 40
	var y = player.position.y - get_viewport_rect().size.y/2 - current_height/2 + offset
	position.y = y
