extends Area2D

onready var player = get_node("../../Player")

func _on_Enemy1_body_entered(body):
	if body.get_collision_layer_bit(0):
		player.take_damage(0.5)
		player.get_node("Camera2D").shake(0.5, 15, 8)
		destroy()

func destroy():
	$AnimatedSprite.play("Death")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Death":
		queue_free()
