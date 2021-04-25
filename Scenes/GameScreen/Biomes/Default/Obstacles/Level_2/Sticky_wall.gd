extends StaticBody2D

var bounciness = 0.1

var speed_factor = 0.1
var acceleration_factor = 4

func _on_StickyArea2D_body_entered(body):
	body.input_handler.entered_sticky_area(speed_factor, acceleration_factor)

func _on_StickyArea2D_body_exited(body):
	body.input_handler.exited_sticky_area()
