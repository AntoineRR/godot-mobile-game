extends Area2D

var value = 1

func _on_Money_body_entered(_body):
	UserData.add_money(value)
	queue_free()
