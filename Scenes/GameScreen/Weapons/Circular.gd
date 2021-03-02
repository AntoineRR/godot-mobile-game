extends RigidBody2D

onready var player = get_node("../")
onready var tilemap = get_node("../../TileMap")

func _on_Circular_body_shape_entered(body_id, body, body_shape, area_shape):
	if body != player:
		print(body_shape)
		if body == tilemap:
			print(body_shape)
			print(Physics2DServer.body_get_shape_metadata(RID(body), body_shape))
