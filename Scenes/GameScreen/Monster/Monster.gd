extends AnimatedSprite

### Variables ###

var current_height = frames.get_frame(animation, frame).get_size().y
var offset_step = current_height / GameManager.max_player_health
onready var player = get_node("../Player")

### Node Methods ###

func _process(_delta):
	position = get_new_position()

### Custom Methods ###

func get_new_position() -> Vector2:
	var pos = position
	var offset = (GameManager.max_player_health - player.player_health) * offset_step
	var y = player.position.y - get_viewport_rect().size.y/2 - current_height/2 + offset
	if y > pos.y:
		pos.y = y
	return pos

