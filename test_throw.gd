extends Control

var tex = load("res://Art/Assets/page.png")
var turny = -1
var page_length = 0
var cur_trans = Transform2D()
var default_font
var test_page = ["Alice was beginning", "to get very tired", "of sitting by her", "sister on the bank"]
var test_page_2 = ["having nothing to", "do: once or twice", "she had peeped", "into the book her"]

var x_x = 1
var y_x = 0
var o_x = 0
var x_y = 0
var y_y = 1
var o_y = 0

var throw = 0


func _ready():
	default_font = DynamicFont.new()
	default_font.font_data = load("res://Art/Fonts/m3x6.ttf")
	default_font.extra_spacing_top = -4
	default_font.extra_spacing_bottom = -1
	default_font.extra_spacing_space = -1


func _draw():
	draw_set_transform_matrix(Transform2D(Vector2(x_x, x_y), Vector2(y_x, y_y), Vector2(o_x, o_y*x_y)))
	draw_rect(Rect2(0, 0, 100, 100), Color(1, 1, 1))
	for i in range(len(test_page)):
		draw_string(default_font, Vector2(0, 12*i), test_page[i], Color(0.1, 0.1, 0.1))


func _physics_process(delta):
	update()


func _on_x_x_value_changed(value):
	x_x = value

func _on_y_x_value_changed(value):
	y_x = value

func _on_o_x_value_changed(value):
	o_x = value

func _on_x_y_value_changed(value):
	x_y = value

func _on_y_y_value_changed(value):
	y_y = value

func _on_o_y_value_changed(value):
	o_y = value
