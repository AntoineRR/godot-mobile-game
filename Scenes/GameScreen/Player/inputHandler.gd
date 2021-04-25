# Handle user input
# Inputs can come from an android device touch screen or a keyboard

extends Node2D

class_name InputHandler

# Nodes
onready var player = get_node("../")
onready var max_speed_timer = get_node("TimeAtMaxSpeed")
onready var weapon_activation_delay_timer = get_node("WeaponActivationDelay")
onready var sticky_delay_timer = get_node("StickyDelay")

# Player movement variables
export var max_x_speed = 400
export var max_y_speed = 800
export var y_acceleration = 0.01
export var x_friction = 0.1

var max_speed = false

# Sticky variables
var speed_factor = 1
var acceleration_factor = 1
var sticked = 0 # Using and not a bool in case we are in multiple sticking areas

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
						player.velocity.x += -max_x_speed*speed_factor
					else:
						player.velocity.x += max_x_speed*speed_factor
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
			velocity.x += -max_x_speed*speed_factor
			max_speed = true
			max_speed_timer.start()
		elif Input.is_action_just_pressed("ui_right"):
			velocity.x += max_x_speed*speed_factor
			max_speed = true
			max_speed_timer.start()
		elif not max_speed:
			velocity.x = lerp(velocity.x, 0, x_friction)
	
	velocity.y = lerp(velocity.y, max_y_speed*speed_factor, y_acceleration*acceleration_factor)
	
	return velocity

func entered_sticky_area(new_speed_factor, new_acceleration_factor):
	if new_speed_factor < speed_factor:
		speed_factor = new_speed_factor
	if new_acceleration_factor > acceleration_factor:
		acceleration_factor = new_acceleration_factor
	sticked += 1

func exited_sticky_area():
	sticked -= 1
	if sticked == 0:
		speed_factor = 1
		acceleration_factor = 1

func hit_sticky_spit(new_speed_factor, duration):
	speed_factor = new_speed_factor
	acceleration_factor = 3
	sticked += 1
	sticky_delay_timer.wait_time = duration
	sticky_delay_timer.start()

func _on_TimeAtMaxSpeed_timeout():
	max_speed = false

func _on_WeaponActivationDelay_timeout():
	if touches.size() > 1:
		player.use_weapon()

func _on_StickyDelay_timeout():
	sticked -= 1
	if sticked == 0:
		speed_factor = 1
		acceleration_factor = 1
