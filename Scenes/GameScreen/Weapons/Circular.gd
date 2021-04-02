extends Area2D

var cooldown = 5

func _ready():
	get_node("Duration").start()

func _on_Circular_area_entered(area):
	area.destroy()

func _on_Duration_timeout():
	call_deferred("queue_free")

