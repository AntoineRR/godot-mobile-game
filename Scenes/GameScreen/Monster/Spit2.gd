extends Area2D

onready var player = get_node("../Player")

export (PackedScene) var fragment
export var crachat_hp = 300

var y_speed = 1000

func _process(delta):
	position.y += y_speed * delta
	if position.y > player.position.y + get_viewport().size.y:
		queue_free()

func _on_Crachat2_body_entered(_body):
	player.reduce_velocity(crachat_hp)
	player.get_node("Camera2D").shake(0.5, 15, 8)
	destroy()

func _on_Crachat2_area_entered(_area):
	explode()
	destroy()

func explode():
	for _i in range(5):
		var frag = fragment.instance()
		frag.position = position
		get_node("../").call_deferred("add_child", frag)

func destroy():
	queue_free()

