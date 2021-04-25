extends Area2D

var speed_factor = 0.25
var duration = 4

var y_speed = 1000

onready var player = get_node("../Player")

func _process(delta):
	position.y += y_speed * delta
	if position.y > player.position.y + get_viewport().size.y:
		queue_free()

func _on_StickySpit_1_body_entered(body):
	player.input_handler.hit_sticky_spit(speed_factor, duration)
	destroy()

func destroy():
	queue_free()
