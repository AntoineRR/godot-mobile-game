extends Control

onready var views = get_node("Views")
onready var swipe_tween = get_node("Views/SwipeTween")

var swiping = false
var _original_position = Vector2.ZERO
var _swipe_point = Vector2.ZERO
var previous_point = Vector2.ZERO
var previous_time = 0
var threshold = 150
var playback_speed = 10

export var views_elts = []
var views_elts_pos = []

export var focused_view = 0

func _ready():
	for i in range(views_elts.size()):
		views_elts_pos.append(get_node(views_elts[i]).rect_global_position.x)
	views.rect_global_position.x = -views_elts_pos[focused_view]

func _input(event):
	if event is InputEventMouseButton and event.pressed: 
		if ((event.button_index == BUTTON_LEFT) or (event.button_index == BUTTON_RIGHT)):
			if not swiping:
				swipe_tween.stop_all()
				_swipe_point = event.position
				previous_point = event.position
				previous_time = OS.get_ticks_msec()
				_original_position = views.rect_global_position
				swiping = true
	if event is InputEventMouseButton and not event.pressed:
		swiping = false
		var distance = event.position.x - _swipe_point.x
		if abs(distance) > threshold:
			if distance > 0 and focused_view > 0:
				focused_view -= 1
			elif distance < 0 and focused_view < views_elts_pos.size() - 1:
				focused_view += 1
		move_to(Vector2(-views_elts_pos[focused_view], views.rect_global_position.y))
	if event is InputEventMouseMotion:
		if swiping:
			views.rect_global_position.x = _original_position.x + (event.position.x - _swipe_point.x)
			previous_point = event.position

func move_to(target):
	swipe_tween.interpolate_property(views, "rect_global_position", views.rect_global_position, target, Tween.TRANS_CIRC, Tween.EASE_OUT)
	swipe_tween.start()
