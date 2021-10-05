extends Control

export (String) var ingredient_name

onready var left_page : Node = get_node("Page_Left")
onready var right_page : Node = get_node("Page_Right")
onready var left_num : Node = get_node("Page_Number_Left")
onready var right_num : Node = get_node("Page_Number_Right")

var dialogs_folder = 'res://Writing/Books'
var cur_page = 0
var cur_book = 'Recipe_Book'
var scroll_size = 419


func _ready():
	process_book(cur_book)
	left_page.get_v_scroll().allow_greater = true
	right_page.get_v_scroll().allow_greater = true
	set_page()


func process_book(file_id):
	var file = File.new()
	file.open("%s/%s.md" % [dialogs_folder, file_id], file.READ)
	var file_text = file.get_as_text()
	left_page.bbcode_text = file_text
	right_page.bbcode_text = file_text


func _on_x_button_pressed():
	owner.full_cauldron.show()
	hide()



func set_page():
	left_page.get_v_scroll().value = scroll_size * cur_page
	right_page.get_v_scroll().value = scroll_size * (cur_page + 1)
	left_num.text = str(cur_page + 1)
	right_num.text = str(cur_page + 2)


func _on_Button_Left_pressed():
	if cur_page > 1:
		cur_page -= 2
		set_page()


func _on_Button_Right_pressed():
	if cur_page < 9996:
		cur_page += 2
		set_page()


func _on_Timer_timeout():
	process_book(cur_book)

