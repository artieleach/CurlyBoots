extends Node2D
onready var handle = get_node("Handle")

var handle_held = false
var last_pos = 0
var rotational_speed = 0

export var teeth = 8
export var gear_size = 10
export var movement_range = Vector2(-180, 180)
export var can_rotate = true
export var max_free_spin = 0.05
export var friction = 0.98
export var initial_angle = 0
export(int, 1, 40, 1) var arm_length = 21
export var click = 0
export var has_handle = true

const BLACK = Color("141013")
const GREY = Color("333941")
const LIGHT_GREY = Color("4a5462")
const SHINE = Color("6d758d")
const ZERO = Vector2(0, 0)

var move_range_rad
var click_rad
var my_rot
var lever_rot
var cur_pos = ZERO


func _ready():
	handle.visible = has_handle
	move_range_rad = Vector2(deg2rad(movement_range.x), deg2rad(movement_range.y))
	click_rad = deg2rad(click)
	lever_rot = clamp(deg2rad(initial_angle), move_range_rad.x, move_range_rad.y)


func _draw():
	draw_circle(ZERO, gear_size, BLACK)
	for i in range(teeth):
		cur_pos = Vector2(gear_size*cos((TAU/teeth)*i+lever_rot), gear_size*sin((TAU/teeth)*i+lever_rot))
		draw_circle(cur_pos, 4.5, BLACK)
		draw_circle(cur_pos, 3.5, GREY)
	draw_set_transform(ZERO, lever_rot/10, Vector2(1, 1))
	draw_circle(ZERO, gear_size-1, GREY)
	draw_circle(ZERO, gear_size-2, LIGHT_GREY)
	draw_set_transform(ZERO, lever_rot, Vector2(1, 1))
	draw_rect(Rect2(0, -2, arm_length, 4), BLACK)
	if abs(lever_rot) < PI/2:
		draw_rect(Rect2(0, -1, arm_length, 1), LIGHT_GREY)
		draw_rect(Rect2(0, 0, arm_length, 1), GREY)
	else:
		draw_rect(Rect2(0, -1, arm_length, 1), GREY)
		draw_rect(Rect2(0, 0, arm_length, 1), LIGHT_GREY)


func _physics_process(delta):
	update()
	last_pos = lever_rot
	if handle_held:
		lever_rot = lerp_angle(lever_rot, clamp(get_angle_to(get_global_mouse_position()), move_range_rad.x, move_range_rad.y), 0.1)
	if can_rotate:
		lever_rot += rotational_speed
	if click != 0:
		lever_rot = lerp_angle(lever_rot, stepify(lever_rot, click_rad), 0.2)
	handle.rect_position = Vector2(arm_length*cos(lever_rot) - 4, arm_length*sin(lever_rot) - 4)
	lever_rot = wrapf(lever_rot, -PI, PI)
	my_rot = lever_rot
	if abs(rotational_speed) > max_free_spin:
		rotational_speed *= friction
	lever_rot = stepify(lever_rot, 0.005)


func _on_Handle_button_down():
	handle_held = true


func _on_Handle_button_up():
	handle_held = false
	rotational_speed = clamp(lever_rot - last_pos, -0.8, 0.8)


func _on_Stopper_pressed():
	rotational_speed *= 0.1
