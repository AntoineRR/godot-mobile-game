extends AnimatedSprite

### Variables ###

var current_height = frames.get_frame(animation, frame).get_size().y
onready var player = get_node("../Player")

# Monster speed
var speed = 200
var seconds_before_catching_player = 3

### Signals ###

signal caught_player

### Node Methods ###

func _ready():
	position.y = player.position.y - speed * seconds_before_catching_player

func _process(delta):
	position = get_new_position(delta)
	check_if_player_caught()

### Custom Methods ###

func get_new_position(delta) -> Vector2:
	var pos = position
	var player_relative_position = player.position.y - pos.y
	if player_relative_position > speed * seconds_before_catching_player:
		pos.y = player.position.y - speed * seconds_before_catching_player
	else:
		pos.y += speed * delta

	return pos

func check_if_player_caught():
	if position.y + current_height/2 >= player.position.y:
		emit_signal("caught_player")
