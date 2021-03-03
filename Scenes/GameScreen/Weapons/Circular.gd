extends Area2D

var cooldown = 5

func _ready():
	get_node("Duration").start()

func _on_Circular_body_entered(body):
	if body.destroyable:
		body.call_deferred("queue_free")

func _on_Duration_timeout():
	call_deferred("queue_free")
