extends Area2D

func _on_Circular_body_entered(body):
	body.call_deferred("queue_free")
