extends Label

func set_msg(msg):
	text = msg
	get_node("Duration").start()

func _on_Duration_timeout():
	queue_free()
