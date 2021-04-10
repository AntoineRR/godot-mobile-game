extends Area2D

const MAX_FRAGMENTATION = 8

export var max_hp = 100.0
export var hp = 100.0
export var moving_range = 50.0
export var moving_speed = 5.0

var start_position
var rand_offset = rand_range(0, moving_range)
var moving_var = 0.0

onready var crack_material = get_node("AnimatedSprite").material

func _ready():
	var fragmentation = (1 - (hp/max_hp)) * MAX_FRAGMENTATION
	crack_material.set_shader_param("fragmentation", fragmentation)
	start_position = position

func _process(delta):
	position.x = start_position.x + sin(moving_var + rand_offset) * moving_range
	moving_var += delta * moving_speed

func descrease_hp(value):
	hp -= value
	var fragmentation = (1 - (hp/max_hp)) * MAX_FRAGMENTATION
	crack_material.set_shader_param("fragmentation", fragmentation)
	if hp <= 0:
		destroy()

func destroy():
	queue_free()


func _on_Moving_obstacle_1_body_entered(body):
	# body should always be the player
	body.reduce_velocity(hp)
	destroy()
