extends Area2D

var value = 1

onready var player = get_node("../Player")

func _on_Money_body_entered(body):
	if body == player:
		UserData.add_money(value)
		queue_free()
