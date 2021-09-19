extends AnimatedSprite

### Exports ###

export (Array, PackedScene) var projectiles

### Variables ###

onready var player = get_node("../Player")
onready var projectile_reload_timer = get_node("ProjectileReload")

var current_height = frames.get_frame(animation, frame).get_size().y

# Monster speed
var speed = 400
var seconds_before_catching_player = 3

# Projectiles speed
var min_proj_speed = 900
var max_proj_speed = 2000

### Signals ###

signal caught_player

### Node Methods ###

func _ready():
	position.y = player.position.y - speed * seconds_before_catching_player

func _process(delta):
	position = get_new_position(delta)
	check_if_player_caught()

### Custom Methods ###

func update_parameters():
	speed = GameManager.biome.get_level().monster_speed
	min_proj_speed = speed * 2.5
	max_proj_speed = speed * 5
	seconds_before_catching_player = GameManager.biome.get_level().n_seconds_player_safe
	projectile_reload_timer.wait_time = GameManager.biome.get_level().projectile_reload_time

func get_new_position(delta) -> Vector2:
	var pos = position
	var player_relative_position = player.position.y - pos.y
	if player_relative_position > speed * seconds_before_catching_player:
		pos.y = max(speed, player.position.y - speed * seconds_before_catching_player)
	else:
		pos.y += speed * delta

	return pos

func check_if_player_caught():
	# Temporary, will change later
	if position.y + current_height/4 >= player.position.y:
		emit_signal("caught_player")


func _on_ProjectileReload_timeout():
	var proj_index
	if GameManager.level == 0:
		proj_index = 0
	else:
		proj_index = 2
	var projectile = projectiles[proj_index].instance()
	var proj_speed = min_proj_speed + randi() % (max_proj_speed - min_proj_speed)
	projectile.y_speed = proj_speed
	projectile.position.x = randi() % int(get_viewport().size.x)
	projectile.position.y = position.y
	projectile.z_index = 2
	get_node("../").add_child(projectile)
