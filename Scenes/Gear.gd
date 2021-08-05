extends AnimatedSprite

onready var knob = get_node("Knob")
onready var handle = get_node("Handle")

var handle_held = false
var last_pos = 0
var rotational_speed = 0

export var movement_range = Vector2(-180, 180)
export var can_rotate = true
export var const_speed = 0.05
export var friction = 0.98
export var initial_angle = 0
export(int, 1, 40, 1) var length = 21
export var click = 0
export var has_handle = true
export var has_gear = true

var move_range_rad
var click_rad

func _ready():
	handle.visible = has_handle
	knob.visible = has_handle
	if has_gear == false:
		self_modulate = Color('00000000')
	knob.scale.x = length
	move_range_rad = Vector2(deg2rad(movement_range.x), deg2rad(movement_range.y))
	click_rad = deg2rad(click)
	knob.rotation = clamp(deg2rad(initial_angle), move_range_rad.x, move_range_rad.y)
	print(move_range_rad)


func _physics_process(delta):
	if handle_held:
		last_pos = knob.rotation
		knob.rotation = lerp_angle(knob.rotation, clamp(get_angle_to(get_global_mouse_position()), move_range_rad.x, move_range_rad.y), 0.1)
	elif can_rotate:
		knob.rotate(rotational_speed)
		if knob.rotation > PI:
			knob.rotation = -PI
	if click != 0:
		knob.rotation = lerp_angle(knob.rotation, stepify(knob.rotation, click_rad), 0.2)
	handle.rect_position = Vector2(length*cos(knob.rotation) - 4, length*sin(knob.rotation) - 4)
	frame = int(floor(knob.rotation_degrees/-7.5) + 24) % 6
	if abs(rotational_speed) > const_speed:
		rotational_speed *= friction


func _on_Handle_button_down():
	handle_held = true


func _on_Handle_button_up():
	handle_held = false
	if can_rotate:
		rotational_speed = clamp(knob.rotation - last_pos, -0.8, 0.8)


func _on_TextureButton_pressed():
	rotational_speed = 0
