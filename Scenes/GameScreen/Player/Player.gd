extends KinematicBody2D

### Variables ###

# Movement
export var max_x_speed = 200
export var max_y_speed = 400
export var y_acceleration = 0.005
export var friction = 0.05

var velocity = Vector2.ZERO
var stop = false
var max_speed = false

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
				max_speed = true
				get_node("TimeAtMaxSpeed").start()

### Custom Methods ###

func update_velocity(_delta):
	if not stop:
		if GameManager.os_name == "Android":
			if not max_speed:
				velocity.x = lerp(velocity.x, 0, friction)
		else:
			if Input.is_action_just_pressed("ui_left"):
				velocity.x = -max_x_speed
				max_speed = true
				get_node("TimeAtMaxSpeed").start()
			elif Input.is_action_just_pressed("ui_right"):
				velocity.x = max_x_speed
				max_speed = true
				get_node("TimeAtMaxSpeed").start()
			elif not max_speed:
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

func _on_TimeAtMaxSpeed_timeout():
	max_speed = false
