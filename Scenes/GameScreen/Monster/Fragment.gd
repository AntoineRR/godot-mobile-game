extends Area2D

var acceleration = 1000
var fragment_hp = 150
var max_x_spread = 200
var max_y_spread = -500

onready var player = get_node("../Player")

var velocity = Vector2.ZERO

func _ready():
	velocity.x = rand_range(-max_x_spread, max_x_spread)
	velocity.y = rand_range(50, -max_y_spread)

func _process(delta):
	position += velocity * delta
	velocity.y += acceleration * delta
	if position.y > player.position.y + get_viewport().size.y:
		queue_free()


func _on_Fragment_body_entered(_body):
	player.reduce_velocity(fragment_hp)
	player.get_node("Camera2D").shake(0.5, 15, 8)
	destroy()

func destroy():
	queue_free()
