extends Area2D

onready var player = get_node("../Player")

func _on_Enemy1_body_entered(body):
	if body.get_collision_layer_bit(0):
		player.take_damage(0.5)
		queue_free()
