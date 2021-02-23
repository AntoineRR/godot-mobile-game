extends KinematicBody2D

### Variables ###

# Movement
var is_holding = false
var x_direction = 1
var max_x_speed = 100
var max_y_speed = 400
var x_acceleration = 0.05
var y_acceleration = 0.005
var friction = 0.02
var velocity = Vector2.ZERO
var stop = false

### Signals ###

signal player_died

### Node Methods ###

func _process(delta):
	update_velocity(delta)
	get_node("Label").text = str(UserData.money)

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _unhandled_input(event):
	if GameManager.os_name == "Android":
		if event is InputEventScreenTouch:
			if event.pressed:
				is_holding = true
				if event.position.x < get_viewport_rect().size.x / 2:
					x_direction = -1
				else:
					x_direction = 1
			else:
				is_holding = false

### Custom Methods ###

func update_velocity(delta):
	if not stop:
		if GameManager.os_name == "Android":
			if is_holding:
				velocity.x = lerp(velocity.x, x_direction * max_x_speed, x_acceleration)
			else:
				velocity.x = lerp(velocity.x, 0, friction)
		else:
			if Input.is_action_pressed("ui_left"):
				velocity.x = lerp(velocity.x, -max_x_speed, x_acceleration)
			elif Input.is_action_pressed("ui_right"):
				velocity.x = lerp(velocity.x, max_x_speed, x_acceleration)
			else:
				velocity.x = lerp(velocity.x, 0, friction)
		
		velocity.y = lerp(velocity.y, max_y_speed, y_acceleration)

func take_damage(duration):
	if not stop:
		velocity = Vector2(0,10)
		stop = true
		var timer = get_node("../InvicibilityFrames")
		timer.wait_time = duration
		timer.start()
		yield(timer, "timeout")
		stop = false

func _on_Monster_caught_player():
	emit_signal("player_died")
