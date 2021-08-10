extends Sprite

export (String) var ingredient_name

onready var left_page : Node = get_node("Page_Left")
onready var right_page : Node = get_node("Page_Right")
onready var left_num : Node = get_node("Page_Number_Left")
onready var right_num : Node = get_node("Page_Number_Right")
onready var tween : Node = get_node("Tween")

var dialogs_folder = 'res://Writing/Books'
var book = []
var cur_page = 0
var right_page_texture
var default_font
var page_turn = 0
var drawing = false

func _ready():
	right_page_texture = load("res://Art/Assets/page.png")
	default_font = DynamicFont.new()
	default_font.font_data = load("res://Art/Fonts/m3x6.ttf")
	default_font.extra_spacing_top = -4
	default_font.extra_spacing_bottom = -1
	default_font.extra_spacing_space = -1
	process_book('book_1')
	set_page()
	# default_font = right_page.get_font("default_font")


func process_book(file_id):
	var file = File.new()
	file.open("%s/%s.txt" % [dialogs_folder, file_id], file.READ)
	var file_text = file.get_as_text()
	var words = file_text.split(' ')
	var lines = []
	var i = 0
	while i < len(words):
		var line = ''
		while i < len(words) and default_font.get_string_size(line + words[i]).x < 97:
			line = line + words[i] + ' '
			i += 1
		if not(line):
			line = words[i]
			i += 1
		lines.append(line)
	for j in range(0, len(lines), 10):
		book.append(lines.slice(j, j+10))
	print(book[0], book[1])


func _on_TextureButton_pressed():
	hide()


func set_page():
	if cur_page < len(book):
		var out = ''
		for i in book[cur_page]:
			out += i + "\n"
		left_page.bbcode_text = out
	else:
		left_page.clear()
	left_num.text = str(cur_page+1)
	right_num.text = str(cur_page + 2)
	if cur_page + 1 < len(book):
		var out = ''
		for i in book[cur_page+1]:
			out += i + "\n"
		right_page.bbcode_text = out
	else:
		right_page.clear()


func _on_Button_Left_pressed():
	drawing = true
	tween.interpolate_property(self, "page_turn", -PI/2, PI/2, 1, Tween.TRANS_LINEAR)
	tween.start()
	left_page.clear()
	yield(get_tree().create_timer(1), "timeout")
	if cur_page > 1:
		cur_page -= 2
		set_page()


func _on_Button_Right_pressed():
	drawing = true
	tween.interpolate_property(self, "page_turn", PI/2, -PI/2, 1, Tween.TRANS_LINEAR)
	tween.start()
	right_page.clear()
	yield(get_tree().create_timer(1), "timeout")
	if cur_page < 9996:
		cur_page += 2
		set_page()


func _physics_process(delta):
	if drawing:
		update()


func _draw():
	draw_set_transform_matrix(Transform2D(Vector2(sin(page_turn), 0), Vector2(0, 1), Vector2(119, 1)))
	draw_texture(right_page_texture, Vector2(0, 0))
	if page_turn > 0:
		for line in range(len(book[cur_page + 1])):
			if book[cur_page+1][line]:
				draw_string(default_font, Vector2(1, 9*line+21), book[cur_page+1][line], Color(0.1, 0.1, 0.1))
			else:
				printt("here", book[cur_page+1][line])
	else:
		draw_set_transform_matrix(Transform2D(Vector2(sin(-page_turn), 0), Vector2(0, 1), Vector2(sin(page_turn)*98+119, 1)))
		if cur_page + 2 < len(book):
			for line in range(len(book[cur_page+2])):
				if book[cur_page+2][line]:
					draw_string(default_font, Vector2(1, 9*line+21), book[cur_page+2][line], Color(0.1, 0.1, 0.1))
				else:
					printt("here", book[cur_page+1][line])


func _on_HSlider_value_changed(value):
	page_turn = value


func _on_Tween_tween_all_completed():
	drawing = false
