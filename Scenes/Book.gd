extends Sprite

export (String) var ingredient_name

onready var left_page : Node = get_node("Page_Left")
onready var right_page : Node = get_node("Page_Right")
onready var left_num : Node = get_node("Page_Number_Left")
onready var right_num : Node = get_node("Page_Number_Right")

var dialogs_folder = 'res://Writing/Books'
var book
var cur_page = 1
var right_page_texture
var default_font
var page_turn = 0

func _ready():
	initiate('book_1')
	right_page_texture = load("res://Art/Assets/page.png")
	default_font = DynamicFont.new()
	default_font.font_data = load("res://Art/Fonts/m3x6.ttf")
	default_font.extra_spacing_top = -4
	default_font.extra_spacing_bottom = -1
	default_font.extra_spacing_space = -1
	process_book("book_1")
	# default_font = right_page.get_font("default_font")


func initiate(file_id): # Load the whole dialog into a variable
	var file = File.new()
	file.open('%s/%s.json' % [dialogs_folder, file_id], file.READ)
	if GlobalVars.debug:
		print('%s/%s.json' % [dialogs_folder, file_id])
	var json = file.get_as_text()
	book = JSON.parse(json).result
	file.close()
	set_page()


func process_book(file_id):
	var file = File.new()
	file.open("%s/%s.txt" % [dialogs_folder, file_id], file.READ)
	var file_text = file.get_as_text()
	var lines = []
	var cur_line = ''
	var start = 0
	var stop = 1
	var total_width = 0
	while start < len(file_text):
		while total_width < 98 and stop < len(file_text):
			cur_line = file_text.substr(start, stop)
			total_width = default_font.get_string_size(cur_line).x
			stop += 1
		while cur_line[-1] != ' ':
			cur_line = cur_line.substr(0, len(cur_line)-1)
			stop -= 1
		lines.append(cur_line)
		start += stop - 1
		stop = 1
		total_width = 1
	for i in lines:
		print(i)

func _on_TextureButton_pressed():
	hide()


func set_page():
	if book.has("%s" % str(cur_page)):
		left_page.bbcode_text = book['%s' % str(cur_page)]
	else:
		left_page.bbcode_text = ''
	left_num.text = str(cur_page)
	right_num.text = str(cur_page + 1)
	if book.has("%s" % str(cur_page + 1)):
		right_page.bbcode_text = book['%s' % str(cur_page + 1)]
	else:
		right_page.bbcode_text = ''


func _on_Button_Left_pressed():
	if cur_page > 2:
		cur_page -= 2
		set_page()


func _on_Button_Right_pressed():
	if cur_page < 9997:
		cur_page += 2
		set_page()


func _draw():
	draw_set_transform_matrix(Transform2D(Vector2(1, 0), Vector2(0, 1), Vector2(0, 0)))
	draw_texture(right_page_texture, Vector2(0, 0))
	if page_turn > 0:
		for i in range(len(right_page.text)):
			draw_string(default_font, Vector2(1, 12*i+21), right_page.text, Color(0.1, 0.1, 0.1))
	else:
		draw_set_transform_matrix(Transform2D(Vector2(sin(-page_turn), 0), Vector2(0, 1), Vector2(sin(page_turn)*98, 0)))
		if book.has("%s" % str(cur_page + 2)):
			for i in range(len(book['%s' % str(cur_page + 2)])):
				draw_string(default_font, Vector2(1, 12*i+21), book['%s' % str(cur_page + 2)], Color(0.1, 0.1, 0.1))

