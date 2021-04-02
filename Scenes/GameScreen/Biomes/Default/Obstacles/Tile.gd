extends Node

const MAX_FRAGMENTATION = 8

export var max_hp = 100.0
export var hp = 100.0

onready var material = get_node("AnimatedSprite").material

func _ready():
	var fragmentation = (1 - (hp/max_hp)) * MAX_FRAGMENTATION
	material.set_shader_param("fragmentation", fragmentation)

func descrease_hp(value):
	hp -= value
	var fragmentation = (1 - (hp/max_hp)) * MAX_FRAGMENTATION
	material.set_shader_param("fragmentation", fragmentation)
	if hp <= 0:
		destroy()

func destroy():
	queue_free()


func _on_Obstacle_body_entered(body):
	# body should always be the player
	body.reduce_velocity(hp)
	destroy()
