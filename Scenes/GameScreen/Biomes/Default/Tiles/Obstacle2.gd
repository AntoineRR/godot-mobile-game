extends Node2D

onready var rigid_body = get_node("../")

func _on_RigidBody2D_body_entered(_body):
	rigid_body.gravity_scale = 5
