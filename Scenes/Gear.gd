extends AnimatedSprite

onready var knob = get_node("Knob")
onready var handle = get_node("Handle")

var handle_held = false
var last_pos = 0
var rotational_speed = 0
var throw = 0

var length = 24

func _physics_process(delta):
	if handle_held:
		last_pos = knob.rotation
		knob.rotation = get_angle_to(get_global_mouse_position())
	else:
		knob.rotate(rotational_speed)
		if knob.rotation > PI:
			knob.rotation = -PI
	handle.rect_position = Vector2(length*cos(knob.rotation) - 4, length*sin(knob.rotation) - 4)
	frame = int(floor(knob.rotation_degrees/-7.5) + 24) % 6
	if abs(rotational_speed) > 0.01:
		rotational_speed *= 0.98
	else:
		rotational_speed = 0



func _on_Handle_button_down():
	handle_held = true


func _on_Handle_button_up():
	handle_held = false
	rotational_speed = knob.rotation - last_pos
	
