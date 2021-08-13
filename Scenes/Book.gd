extends Sprite

export (String) var ingredient_name

onready var left_page : Node = get_node("Page_Left")
onready var right_page : Node = get_node("Page_Right")
onready var left_num : Node = get_node("Page_Number_Left")
onready var right_num : Node = get_node("Page_Number_Right")

const TEXT_WIDTH = 96

var dialogs_folder = 'res://Writing/Books'
var book = []
var cur_page = 0
var default_font
var page_turn = 1
var drawing = false


func _ready():
	default_font = DynamicFont.new()
	default_font.font_data = load("res://Art/Fonts/m3x6.ttf")
	default_font.extra_spacing_top = -4
	default_font.extra_spacing_bottom = -1
	default_font.extra_spacing_space = -1
	process_book('book_2')
	set_page()


func process_book(file_id):
	var file = File.new()
	file.open("%s/%s.txt" % [dialogs_folder, file_id], file.READ)
	var file_text = file.get_as_text()
	var words = file_text.split(' ')
	var lines = []
	var i = 0
	while i < len(words):
		var line = ''
		while i < len(words) and default_font.get_string_size(line + words[i]).x < TEXT_WIDTH:
			if '<PB>' in words[i]:
				for j in range((10-len(lines)) % 10):
					lines.append('\n')
			else:
				line = line + words[i] + ' '
			i += 1
		lines.append(line)
	for j in range(0, len(lines), 10):
		book.append(lines.slice(j, j+10))


func _on_x_button_pressed():
	hide()


func set_page():
	if cur_page < len(book):
		var out = ''
		for i in book[cur_page]:
			out += i
		left_page.bbcode_text = out
	else:
		left_page.clear()
	left_num.text = str(cur_page+1)
	right_num.text = str(cur_page + 2)
	if cur_page + 1 < len(book):
		var out = ''
		for i in book[cur_page+1]:
			out += i
		right_page.bbcode_text = out
	else:
		right_page.clear()


func _on_Button_Left_pressed():
	if cur_page > 1:
		cur_page -= 2
		set_page()


func _on_Button_Right_pressed():
	if cur_page < 9996:
		cur_page += 2
		set_page()
