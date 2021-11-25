extends Node2D

onready var cauldron = get_node("Counter/ViewportContainer/Viewport/Cauldron")
onready var dialog
onready var day_summary = get_node("Day_Summary")
onready var options_menu = get_node("OptionsMenu")
onready var tween = get_node("Tween")
onready var schedule
onready var bookshelf = get_node("Counter/Bookshelf")
onready var ingredient_shelf = get_node("Counter/Ingredient_Shelf")
onready var radial_shelf = get_node("Counter/Countertop")
onready var book = get_node("Book")
onready var left_button = get_node("Counter/Left_Button")
onready var right_button = get_node("Counter/Right_Button")
onready var clear_button = get_node("Counter/Countertop/Clear_Button")
onready var full_cauldron = get_node("Counter/full_cauldron")
onready var countertop = get_node("Counter/Countertop")
var radial = preload("res://Scenes/Radial.tscn")
var pickable_ingredient = preload("res://Scenes/Ingredient.tscn")

var inventory_ingredients = []
var counters
signal mouse_exited_game_area
signal clear_recent
signal deactivate
signal reset_potion

var current_counter = 0
var radial_states = [
	[2, 2, 2, 2, 4, 3, 1, 7], 
	[3, 1, 8, 1, 3, 4],
	[4, 4, 4, 3, 5, 1, 6],
	[5, 6, 7, 4, 2, 14],
	[8, 11, 9, 14, 8, 11, 9, 10],
	[14, 2, 14, 12, 14, 13]
]

var states = [
	[[8],	[3],		[9, 12],	[10],		[2],		[15]],
	[[10],	[2, 5],		[1],		[8],		[14],		[9]],
	[[17],	[13],		[8, 5],		[2],		[3],		[12]],
	[[14],	[11, 9],	[1],		[16],		[5],		[8]],
	[[9],	[10],		[8],		[12],		[11, 13],	[15]],
	[[14],	[2],		[16],		[8, 6],		[1],		[10]],
	[[15],	[13],		[10],		[7, 11],	[3],		[17]],
	[[1],	[20],		[6],		[4],		[10],		[18]],
	[[16],	[14],		[9],		[19],		[10, 13],	[3]],
	[[20],	[1],		[12],		[9],		[18],		[2]],
	[[19],	[5],		[11],		[7],		[14],		[16]],
	[[13],	[12],		[14],		[3],		[17],		[18]]
	]

func _ready():
	SceneTransition.transition({"Direction": "in", "Destination": "Game"})
	randomize()
	counters = [radial_shelf, ingredient_shelf, bookshelf]
	set_radials()
	cauldron.connect("check_recipe", self, "check_recipe")
	for i in range(40):
		add_ingredient(GlobalVars.ingredient_data.keys()[randi() % 21])


func check_recipe():
	var cur_recipe = []
	GlobalVars.potion_ingredients.sort()
	for i in GlobalVars.potion_ingredients:
		cur_recipe.append(GlobalVars.ingredient_data.keys().find(i))
	for item in GlobalVars.recipes:
		if cur_recipe == item[0]:
			printt(cur_recipe, item[1])
			print(GlobalVars.ingredient_data.keys()[21])
			add_ingredient(GlobalVars.ingredient_data.keys()[GlobalVars.ingredient_data.keys().find(item[1][0])])
	print(cur_recipe)


func set_radials():
	for i in range(6):
		var cur_rad = radial.instance()
		cur_rad.rad_vals = radial_states[i]
		countertop.get_node("HBoxContainer").add_child(cur_rad)
		cur_rad.connect("add_ingredient", self, "add_ingredient")
		cur_rad.center_vals = states[0][i]
		cur_rad.name = '%d' % i
		if i in GlobalVars.rolls:
			cur_rad.setup()


func _on_Game_tree_exiting():
	GlobalVars.save_to_disk()


func add_ingredient(ing_name):
	var cur_ing = pickable_ingredient.instance()
	ingredient_shelf.get_node("GridContainer").add_child(cur_ing)
	inventory_ingredients.append(cur_ing)
	inventory_ingredients.sort()
	cur_ing.setup(ing_name)
	connect("mouse_exited_game_area", cur_ing, "drop_em")
	connect("reset_potion", cur_ing, "reset")
	cur_ing.connect("double_clicked", self, "_on_ingredient_pressed", [cur_ing.ingredient_name])
	cur_ing.connect("added_to_potion", self, "_on_add_to_potion", [cur_ing.ingredient_name])


func _on_add_to_potion(ingredient):
	cauldron.poof.self_modulate = GlobalVars.ingredient_data[ingredient]["color"]
	cauldron.poof.restart()
	cauldron.splash.restart()
	GlobalVars.potion_ingredients.append(ingredient)


func _on_dialog(cur_speaker, spesific_response=null):
	if spesific_response:
		dialog.initiate('%s/%s' % [cur_speaker.name, spesific_response])
	else:
		dialog.initiate('%s/%s_%s' % [cur_speaker.name, cur_speaker.name, cur_speaker.progress])
	cur_speaker.progress += 1


func _on_advance_dialog_pressed():
	if dialog.label.visible_characters == dialog.number_characters:
		dialog.next()


func start_day():
	schedule = ['no one']  # why is this here?
	day_summary.mouse_filter = Control.MOUSE_FILTER_STOP
	if GlobalVars.debug:
		pass


func end_day():
	day_summary.get_node("MarginContainer/Day_Summary_Text").text = "Witching Hour is over.\nDay %d" % GlobalVars.day
	for customer in get_tree().get_nodes_in_group("customers"):
		customer.queue_free()
	$end_of_day.show()
	tween.interpolate_property(day_summary, "color:a", 0, 1, 0.5)
	tween.interpolate_property(day_summary.get_node("MarginContainer/Day_Summary_Text"), "self_modulate:a", 0, 1, 0.5, 0, 2, 1)
	tween.start()
	GlobalVars.day += 1


func _on_Day_Summary_gui_input(event):
	if event is InputEventMouseButton:
		GlobalVars.save_to_disk()
		day_summary.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tween.interpolate_property(day_summary, "color:a", 1, 0, 0.5)
		tween.interpolate_property(day_summary.get_node("MarginContainer/Day_Summary_Text"), "self_modulate:a", 1, 0, 0.5, 0, 2)
		tween.start()
		yield(tween, "tween_completed")
		start_day()
		day_summary.hide()


func _on_Menu_Button_pressed():
	get_tree().paused = true
	options_menu.slide()

func _on_Right_Button_pressed():
	update_counter("right")


func _on_Left_Button_pressed(): 
	update_counter("left")


func update_counter(move_direction):
	if move_direction == "right":
		# hey future me, maybe fix the position of this so it's not hard coded.
		tween.interpolate_property(counters[current_counter], "rect_position:x", 0, -160, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		current_counter = wrapi(current_counter + 1, 0, 3)
		tween.interpolate_property(counters[current_counter], "rect_position:x", 160, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(counters[current_counter], "rect_position:x", 0, 160, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		current_counter = wrapi(current_counter - 1, 0, 3)
		tween.interpolate_property(counters[current_counter], "rect_position:x", -160, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	left_button.pressed = false
	left_button.toggle_mode = false
	left_button.toggle_mode = true
	right_button.pressed = false
	right_button.toggle_mode = false
	right_button.toggle_mode = true


func _on_book_pressed(book_title):
	full_cauldron.hide()
	book.process_book(book_title)
	book.show()


func doulbe_clicked(ingredient):
	book.process_book(ingredient)


func _on_Game_mouse_exited_game_area():
	emit_signal("mouse_exited_game_area")


func _on_Clear_Button_pressed():
	cauldron.poof.self_modulate = Color('4a5462')
	cauldron.poof.restart()
	cauldron.splash.restart()
	inventory_ingredients.clear()
	GlobalVars.potion_ingredients.clear()
	emit_signal("clear_recent")
	emit_signal("reset_potion")
	yield(get_tree().create_timer(0.9), "timeout")
	clear_button.pressed = false
	clear_button.toggle_mode = false
	clear_button.toggle_mode = true


func _on_HSlider_value_changed(value):
	GlobalVars.cauldron_temp = value
	cauldron.set_temp()


func _on_ingredient_pressed(ingredient):
	print(ingredient)
