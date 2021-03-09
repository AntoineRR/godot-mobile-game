# Handle user input
# Inputs can come from an android device touch screen or a keyboard

extends Node2D

class_name InputHandler

# Nodes
onready var player = get_node("../")
onready var max_speed_timer = get_node("TimeAtMaxSpeed")
onready var weapon_activation_delay_timer = get_node("WeaponActivationDelay")

# Player movement variables
export var max_x_speed = 400
export var max_y_speed = 800
export var y_acceleration = 0.01
export var x_friction = 0.1

var max_speed = false

# Input variables
var touches = []

func _input(event):
	if not player.stop:
		if GameManager.os_name == "Android":
			if event is InputEventScreenTouch:
				if event.pressed:
					if not event.index in touches:
						touches.append(event.index)
					
					if event.position.x < get_viewport_rect().size.x / 2:
						player.velocity.x += -max_x_speed
					else:
						player.velocity.x += max_x_speed
					max_speed = true
					max_speed_timer.start()
					
					if touches.size() > 1:
						weapon_activation_delay_timer.start()
						return
				else:
					touches.remove(event.index)

func update_velocity(velocity) -> Vector2:
	if GameManager.os_name == "Android":
		if not max_speed:
			velocity.x = lerp(velocity.x, 0, x_friction)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			player.use_weapon()
			return velocity
		
		if Input.is_action_just_pressed("ui_left"):
			velocity.x += -max_x_speed
			max_speed = true
			max_speed_timer.start()
		elif Input.is_action_just_pressed("ui_right"):
			velocity.x += max_x_speed
			max_speed = true
			max_speed_timer.start()
		elif not max_speed:
			velocity.x = lerp(velocity.x, 0, x_friction)
	
	velocity.y = lerp(velocity.y, max_y_speed, y_acceleration)
	
	return velocity

func _on_TimeAtMaxSpeed_timeout():
	max_speed = false

func _on_WeaponActivationDelay_timeout():
	if touches.size() > 1:
		player.use_weapon()
