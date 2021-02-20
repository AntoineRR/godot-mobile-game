extends Area2D

func _on_Enemy1_body_entered(body):
	var player = get_node("../Player")
	if body == player:
		player.take_damage(0.5)
		queue_free()
