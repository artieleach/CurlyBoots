extends Control

var tex
var turny = -1
var page_length = 0
var cur_trans = Transform2D()
var default_font
var font_holder
var test_page = ["Alice was beginning", "to get very tired", "of sitting by her", "sister on the bank"]
var test_page_2 = ["having nothing to", "do: once or twice", "she had peeped", "into the book her"]


func _ready():
	tex = load("res://Art/Assets/page.png")
	font_holder = DynamicFont.new()
	font_holder.font_data = load("res://Art/Fonts/m5x7.ttf")
	font_holder.extra_spacing_top = -4
	font_holder.extra_spacing_bottom = -1
	font_holder.extra_spacing_space = -1


func _draw():
	draw_set_transform_matrix(Transform2D(Vector2(sin(turny), 0), Vector2(0, 1), Vector2(0, 0)))
	draw_texture(tex, Vector2(0, 0))
	if turny > 0:
		for i in range(len(test_page)):
			draw_string(font_holder, Vector2(1, 12*i+20), test_page[i], Color(0.1, 0.1, 0.1))
	else:
		draw_set_transform_matrix(Transform2D(Vector2(sin(-turny), 0), Vector2(0, 1), Vector2(sin(turny)*98, 0)))
		for i in range(len(test_page_2)):
			draw_string(font_holder, Vector2(1, 12*i+20), test_page_2[i], Color(0.1, 0.1, 0.1))


func _physics_process(delta):
	update()


func _on_HSlider_value_changed(value):
	turny = value
