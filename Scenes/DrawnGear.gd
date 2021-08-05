extends Node2D
onready var handle = get_node("Handle")

var handle_held = false
var last_pos = 0
var rotational_speed = 0

export var teeth = 8
export var gear_size = 10
export var movement_range = Vector2(-180, 180)
export var can_rotate = true
export var const_speed = 0.05
export var friction = 0.98
export var initial_angle = 0
export(int, 1, 40, 1) var arm_length = 21
export var click = 0
export var has_handle = true

var move_range_rad
var click_rad
var my_rot
var lever_rot

func _ready():
	handle.visible = has_handle
	move_range_rad = Vector2(deg2rad(movement_range.x), deg2rad(movement_range.y))
	click_rad = deg2rad(click)
	lever_rot = clamp(deg2rad(initial_angle), move_range_rad.x, move_range_rad.y)
	print(move_range_rad)


func _draw():
	draw_circle(Vector2(0, 0), gear_size, Color.black)
	for i in range(teeth):
		var cur_pos = Vector2(gear_size*cos((TAU/teeth)*i+my_rot), gear_size*sin((TAU/teeth)*i+my_rot))
		draw_circle(cur_pos, 3.5, Color.black)
		draw_circle(cur_pos, 2.5, Color.white)
	draw_circle(Vector2(0, 0), gear_size-1, Color.white)
	draw_set_transform(Vector2(0, 0), lever_rot, Vector2(1, 1))
	draw_rect(Rect2(0, -2, arm_length, 4), Color.black)
	if abs(lever_rot) < PI/2:
		draw_rect(Rect2(0, -1, arm_length, 1), Color.white)
		draw_rect(Rect2(0, 0, arm_length, 1), Color.gray)
	else:
		draw_rect(Rect2(0, -1, arm_length, 1), Color.gray)
		draw_rect(Rect2(0, 0, arm_length, 1), Color.white)
		


func _physics_process(delta):
	update()
	if handle_held:
		last_pos = lever_rot
		lever_rot = lerp_angle(lever_rot, clamp(get_angle_to(get_global_mouse_position()), move_range_rad.x, move_range_rad.y), 0.1)
	elif can_rotate:
		lever_rot += rotational_speed
	if click != 0:
		lever_rot = lerp_angle(lever_rot, stepify(lever_rot, click_rad), 0.2)
	handle.rect_position = Vector2(arm_length*cos(lever_rot) - 4, arm_length*sin(lever_rot) - 4)
	lever_rot = wrapf(lever_rot, -PI, PI)
	my_rot = lever_rot
	if abs(rotational_speed) > const_speed:
		rotational_speed *= friction

func _on_Handle_button_down():
	handle_held = true


func _on_Handle_button_up():
	handle_held = false
	if can_rotate:
		rotational_speed = clamp(lever_rot - last_pos, -0.8, 0.8)
