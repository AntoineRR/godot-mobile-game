extends Area2D

var y_speed = 500

onready var player = get_node("../Player")

func _process(delta):
	position.y += y_speed * delta
	if position.y > player.position.y + get_viewport().size.y:
		queue_free()

func _on_MonsterProjectile_body_entered(body):
	if body == player:
		player.take_damage(0.5)
		queue_free()
