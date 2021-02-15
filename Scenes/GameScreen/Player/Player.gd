extends RigidBody2D

var impulse_value = 50
var impulse = Vector2.ZERO
var is_holding = false

func _process(_delta):
	if is_holding:
		self.apply_impulse(Vector2.ZERO, impulse)
	# Accelerometer input
#	var acc = Input.get_accelerometer()
#	var impulse = Vector2(acc.x * acc_sensilbility, 0)
#	self.apply_impulse(Vector2.ZERO, impulse)

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			is_holding = true
			if event.position.x < get_viewport_rect().size.x / 2:
				impulse = Vector2(-impulse_value,0)
			else:
				impulse = Vector2(impulse_value,0)
		else:
			is_holding = false
