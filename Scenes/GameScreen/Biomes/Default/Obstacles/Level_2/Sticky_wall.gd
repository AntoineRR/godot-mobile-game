extends StaticBody2D

var bounciness = 0.1

func _on_StickyArea2D_body_entered(body):
	body.input_handler.max_y_speed /= 4
	body.input_handler.max_x_speed /= 4
	body.input_handler.y_acceleration *= 2


func _on_StickyArea2D_body_exited(body):
	body.input_handler.max_y_speed *= 4
	body.input_handler.max_x_speed *= 4
	body.input_handler.y_acceleration /= 2
