# Handle user input
# Inputs can come from an android device touch screen or a keyboard

extends Node2D

class_name InputHandler

onready var player = get_node("../")
onready var min_hold_timer = get_node("MinHodingTime")
onready var max_speed_timer = get_node("TimeAtMaxSpeed")

export var max_x_speed = 600
export var max_y_speed = 800
export var y_acceleration = 0.01
export var y_holding_deceleration = 2
export var x_friction = 0.1

var max_speed = false
var is_holding = false
var time_holding_start = 0

func handle_event(event):
	if GameManager.os_name == "Android":
		if event is InputEventScreenTouch:
			if event.pressed:
				if event.position.y > 4 * get_viewport_rect().size.y / 5:
					player.use_weapon()
				else:
					min_hold_timer.start()
					is_holding = true
			else:
				if is_holding:
					var speed = max_x_speed
					if min_hold_timer.is_stopped():
						speed = min(max_x_speed + (OS.get_ticks_msec() - time_holding_start)*2, 1500)
					if event.position.x < get_viewport_rect().size.x / 2:
						player.velocity.x = -speed
					else:
						player.velocity.x = speed
					is_holding = false
					max_speed = true
					max_speed_timer.start()

func update_velocity(delta, velocity) -> Vector2:
	if GameManager.os_name == "Android":
		if not max_speed:
			velocity.x = lerp(velocity.x, 0, x_friction)
		if is_holding and get_node("MinHodingTime").is_stopped():
			velocity.y /= (1 + delta * y_holding_deceleration)
	else:
		if Input.is_action_just_pressed("ui_accept"):
			player.use_weapon()
			return velocity
		
		if Input.is_action_just_pressed("ui_left"):
			is_holding = true
			min_hold_timer.start()
		elif Input.is_action_just_pressed("ui_right"):
			is_holding = true
			min_hold_timer.start()
		elif not max_speed:
			velocity.x = lerp(velocity.x, 0, x_friction)
		
		if is_holding and min_hold_timer.is_stopped():
			velocity.y /= (1 + delta * y_holding_deceleration)
		
		if Input.is_action_just_released("ui_left"):
			var speed = max_x_speed
			if min_hold_timer.is_stopped():
				speed = min(max_x_speed + (OS.get_ticks_msec() - time_holding_start)*2, 1500)
			velocity.x = -speed
			is_holding = false
			max_speed = true
			max_speed_timer.start()
		elif Input.is_action_just_released("ui_right"):
			var speed = max_x_speed
			if min_hold_timer.is_stopped():
				speed = min(max_x_speed + (OS.get_ticks_msec() - time_holding_start)*2, 1500)
			velocity.x = speed
			is_holding = false
			max_speed = true
			max_speed_timer.start()
	
	velocity.y = lerp(velocity.y, max_y_speed, y_acceleration)
	return velocity

func _on_MinHodingTime_timeout():
	time_holding_start = OS.get_ticks_msec()

func _on_TimeAtMaxSpeed_timeout():
	max_speed = false
