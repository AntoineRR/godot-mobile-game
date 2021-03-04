extends KinematicBody2D

### Variables ###

# Movement
export var max_x_speed = 400
export var max_y_speed = 800
export var y_acceleration = 0.01
export var friction = 0.1

# Feedback
export var speed_shake_amplitude_factor = 4
export var speed_shake_frequency = 30

var velocity = Vector2.ZERO
var stop = false
var max_speed = false

# Weapon
export(PackedScene) var weapon
var is_weapon_usable = true

### Signals ###

signal player_died

### Node Methods ###

func _process(delta):
	update_velocity(delta)
	# The shake camera effect needs to be handled by the enemy/projectile when we hit it
	# That is why we check for velocity first, a velocity close to zero means we hit an enemy/projectile
	if velocity.y - 20 > 0:
		# Shake camera when speed increases
		get_node("Camera2D").shake(0.1, speed_shake_frequency, speed_shake_amplitude_factor * velocity.y / max_y_speed)
	get_node("Label").text = str(UserData.money)

func _physics_process(_delta):
	velocity = move_and_slide(velocity, Vector2(0,-1))

func _unhandled_input(event):
	if GameManager.os_name == "Android":
		if not stop:
			if event is InputEventScreenTouch:
				if event.pressed:
					if event.position.y > 4 * get_viewport_rect().size.y / 5:
						use_weapon()
					else:
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
			
			if Input.is_action_just_pressed("ui_accept"):
				use_weapon()
		
		velocity.y = lerp(velocity.y, max_y_speed, y_acceleration)

func use_weapon():
	if is_weapon_usable:
		var w = weapon.instance()
		add_child(w)
		get_node("WeaponCooldown").wait_time = w.cooldown
		get_node("WeaponCooldown").start()
		is_weapon_usable = false

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

func _on_WeaponCooldown_timeout():
	is_weapon_usable = true
