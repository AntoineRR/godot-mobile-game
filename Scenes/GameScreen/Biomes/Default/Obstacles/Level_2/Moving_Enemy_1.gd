extends Area2D

onready var player = get_node("../../Player")

export var moving_range = 50.0
export var moving_speed = 5.0

var start_position
var rand_offset = rand_range(0, moving_range)
var moving_var = 0.0

func _ready():
	start_position = position

func _process(delta):
	position.x = start_position.x + sin(moving_var + rand_offset) * moving_range
	moving_var += delta * moving_speed

func _on_Moving_Enemy1_body_entered(body):
	if body.get_collision_layer_bit(0):
		player.take_damage(0.5)
		player.get_node("Camera2D").shake(0.5, 15, 8)
		destroy()

func destroy():
	queue_free()
