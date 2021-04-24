extends KinematicBody2D

### Variables ###

onready var input_handler = get_node("InputHandler")
onready var weapon_cooldown_timer = get_node("WeaponCooldown")

# Movement
var velocity = Vector2.ZERO
var stop = false

# Feedback
export var speed_shake_amplitude_factor = 4
export var speed_shake_frequency = 30

# Weapon
export(PackedScene) var weapon
var is_weapon_usable = true

### Signals ###

signal player_died
signal player_finished_sub_level

### Node Methods ###

func _process(_delta):
	if not stop:
		velocity = input_handler.update_velocity(velocity)
	
	# The shake camera effect needs to be handled by the enemy/projectile when we hit it
	# That is why we check for velocity first, a velocity close to zero means we hit an enemy/projectile
	if velocity.y - 20 > 0:
		# Shake camera when speed increases
		var amplitude = (speed_shake_amplitude_factor*velocity.y) / input_handler.max_y_speed
		get_node("Camera2D").shake(0.1, speed_shake_frequency, amplitude)
	
	if position.y - GameManager.start_of_sub_level_position > GameManager.biome.get_sub_level_size():
		emit_signal("player_finished_sub_level")
	
	# temp
	get_node("Label").text = str(UserData.money)

func _physics_process(_delta):
	#velocity = move_and_slide(velocity, Vector2(0,-1))
	var collision_infos = move_and_collide(velocity * _delta)
	if collision_infos:
		var bounciness = 0.1
		if collision_infos.collider is StaticBody2D:
			bounciness = collision_infos.collider.bounciness
		if collision_infos.normal.y < -0.9:
			velocity.y = velocity.bounce(collision_infos.normal).y * bounciness
		else:
			velocity.x = velocity.bounce(collision_infos.normal).x * bounciness

### Custom Methods ###

func update_parameters():
	input_handler.max_y_speed = GameManager.biome.get_level().player_max_speed
	input_handler.y_acceleration = GameManager.biome.get_level().player_y_acceleration

func use_weapon():
	if is_weapon_usable:
		var w = weapon.instance()
		add_child(w)
		weapon_cooldown_timer.wait_time = w.cooldown
		weapon_cooldown_timer.start()
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

func reduce_velocity(obstacle_hp, allow_negative=true):
	velocity.y -= obstacle_hp/(velocity.y/1000)
	if not allow_negative:
		velocity.y = max(0, velocity.y)

func _on_Monster_caught_player():
	emit_signal("player_died")

func _on_WeaponCooldown_timeout():
	is_weapon_usable = true
