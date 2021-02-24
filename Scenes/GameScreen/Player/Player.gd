extends KinematicBody2D

### Variables ###

# Movement
var max_x_speed = 200
var max_y_speed = 400
var x_acceleration = 0.1
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
				if event.position.x < get_viewport_rect().size.x / 2:
					velocity.x = -max_x_speed
				else:
					velocity.x = max_x_speed

### Custom Methods ###

func update_velocity(_delta):
	if not stop:
		if GameManager.os_name == "Android":
			velocity.x = lerp(velocity.x, 0, friction)
		else:
			if Input.is_action_just_pressed("ui_left"):
				velocity.x = -max_x_speed
			elif Input.is_action_just_pressed("ui_right"):
				velocity.x = max_x_speed
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
