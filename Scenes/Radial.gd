extends TextureRect

var rad_vals = [1, 1, 10, 1, 2, 3, 4, 5]
var center_vals = [11, 12]

var all_items = []
var radial_items = []
var center_items = []
var radial_button = preload("res://Scenes/Radial_Button.tscn")

onready var tween = get_node("Tween")

var con = 16
var val = 13

func _ready():
	for i in range(len(rad_vals)):
		create_button(rad_vals[i])
	for i in range(len(center_vals)):
		create_button(center_vals[i], true)
	update_buttons(true)


func set_label(txt):
	name = txt
	$CenterContainer/Label.text = txt


func create_button(button_name, center=false):
	var cur_button = radial_button.instance()
	cur_button.connect("mouse_entered", self, "bring_to_front", [cur_button])
	cur_button.connect("mouse_exited", self, "reset_buttons")
	cur_button.connect("pressed", self, "button_pressed", [cur_button])
	if not center:
		add_child(cur_button)
		all_items.append(cur_button)
		radial_items.append(cur_button)
	else:
		add_child(cur_button)
		all_items.append(cur_button)
		center_items.append(cur_button)
	cur_button.setup(GlobalVars.ingredient_data.keys()[button_name])
	return cur_button


func update_buttons(is_instant = false):
	for i in range(len(center_items)):
		var cur_button = center_items[i]
		var new_pos = Vector2(15 + (i - 0.5) * 9, 15)
		cur_button.rect_position = new_pos
	if len(radial_items) > 1:
		for i in range(len(radial_items)):
			var angle = 360 / len(radial_items) * i
			var cur_button = radial_items[i]
			var new_pos = Vector2(
				con + val * cos(angle * PI / 180), 
				con + val * sin(angle * PI / 180))
			if not is_instant:
				tween.interpolate_property(cur_button, "rect_position", cur_button.rect_position, new_pos, 0.4)
				tween.start()
			else:
				cur_button.rect_position = new_pos


func bring_to_front(button):
	if  button.visible:
		for item in all_items:
			if item.visible and item != button:
				tween.interpolate_property(item, "modulate", item.self_modulate, Color(0.4, 0.4, 0.4, 0.6), 0.3)
				tween.start()
		tween.start()
		button.self_modulate = Color(1, 1, 1, 1)


func reset_buttons():
	for item in all_items:
		tween.interpolate_property(item, "modulate", item.self_modulate, Color(1, 1, 1, 1), 0.3)
		tween.start()


func button_pressed(button):
	if radial_items.find(button) != -1:
		radial_items.remove(radial_items.find(button))
		all_items.remove(all_items.find(button))
		update_buttons()
	if center_items.find(button) != -1:
		for item in center_items:
			item.visible = false
			center_items.remove(center_items.find(item))
			all_items.remove(all_items.find(item))
	button.visible = false
	reset_buttons()
	print(button.name)


func _on_HSlider_value_changed(value):
	val = value
	update_buttons()


func _on_HSlider2_value_changed(value):
	con = value
	update_buttons()
