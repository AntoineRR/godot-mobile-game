extends Area2D

export var crachat_hp = 300

var y_speed = 1000

onready var player = get_node("../Player")

func _process(delta):
	position.y += y_speed * delta
	if position.y > player.position.y + get_viewport().size.y:
		queue_free()

func _on_MonsterProjectile_body_entered(_body):
	player.reduce_velocity(crachat_hp)
	player.get_node("Camera2D").shake(0.5, 15, 8)
	destroy()

func destroy():
	queue_free()
