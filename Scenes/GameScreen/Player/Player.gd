extends KinematicBody2D

### Variables ###

# Movement
var is_holding = false
var x_direction = 1
export(int) var x_speed = 100
export(int) var gravity = 100
var velocity = Vector2.ZERO

# Stat
var player_health = 5

### Signals ###

signal player_died

### Node Methods ###

func _process(delta):
	update_velocity(delta)

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _unhandled_input(event):
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
	velocity.x = 0
	if is_holding:
		velocity.x += x_direction * x_speed
	
	# Keyboard input for debug
	if Input.is_action_pressed("ui_left"):
		velocity.x += -x_speed
	if Input.is_action_pressed("ui_right"):
		velocity.x += x_speed
	
	# Increase velocity when player starts falling
	if velocity.y - 0.1 < 0:
		delta += 0.02
	velocity.y += gravity * delta

func decrease_player_health(value):
	player_health -= value
	if player_health <= 0:
		emit_signal("player_died")
