extends Control

onready var views = get_node("Views")
onready var swipe_tween = get_node("Views/SwipeTween")

var swiping = false
var _original_position = Vector2.ZERO
var _swipe_point = Vector2.ZERO

var views_elts_pos = [0,-540,-1080]

func _input(event):
	if event is InputEventMouseButton and event.pressed: 
		if ((event.button_index == BUTTON_LEFT) or (event.button_index == BUTTON_RIGHT)):
			if not swiping:
				_swipe_point = event.position
				_original_position = views.rect_global_position
				swiping = true
	if event is InputEventMouseButton and not event.pressed:
		swiping = false
		var distance = []
		for i in range(views_elts_pos.size()):
			distance.append(abs(views_elts_pos[i] - views.rect_global_position.x))
		var min_index = distance.find(distance.min())
		move_to(Vector2(views_elts_pos[min_index], views.rect_global_position.y))
	if event is InputEventMouseMotion:
		if swiping:
			views.rect_global_position.x = _original_position.x + (event.position.x - _swipe_point.x)

func move_to(target):
	swipe_tween.interpolate_property(views, "rect_global_position", views.rect_global_position, target, Tween.TRANS_QUINT, Tween.EASE_OUT)
	swipe_tween.start()
