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

func _ready():
	initiate('book_1')
	right_page_texture = load("res://Art/Assets/page.png")
	default_font = Control.new().get_font("m5x8.tres")


func initiate(file_id): # Load the whole dialog into a variable
	var file = File.new()
	file.open('%s/%s.json' % [dialogs_folder, file_id], file.READ)
	if GlobalVars.debug:
		print('%s/%s.json' % [dialogs_folder, file_id])
	var json = file.get_as_text()
	book = JSON.parse(json).result
	file.close()
	set_page()


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
