extends Area2D

func _on_Enemy1_body_entered(body):
	var player = get_node("../Player")
	if body == player:
		player.decrease_player_health(1)
		queue_free()
