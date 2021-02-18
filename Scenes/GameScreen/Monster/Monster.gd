extends AnimatedSprite

var current_height = 0
var offset_step = 0

func _ready():
	current_height = frames.get_frame(animation, frame).get_size().y
	offset_step = current_height / GameManager.max_player_health

func _process(_delta):
	var player = get_node("../Player")
	var offset = (GameManager.max_player_health - player.player_health) * offset_step
	var y = player.position.y - get_viewport_rect().size.y/2 - current_height/2 + offset
	if y > position.y:
		position.y = y
