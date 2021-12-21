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
onready var inventory = get_node("Counter/Countertop/VBoxContainer/Inventory")
onready var display_recipe = get_node("Counter/Countertop/RichTextLabel")

var radial_button = preload("res://Scenes/Radial_Button.tscn")
var radial = preload("res://Scenes/Radial.tscn")
var pickable_ingredient = preload("res://Scenes/Ingredient.tscn")
var card = preload("res://Scenes/Card.tscn")

var deck = []
var inventory_ingredients = []
var counters
signal mouse_exited_game_area
signal clear_recent
signal deactivate
signal reset_potion

var current_counter = 0

func _ready():
	SceneTransition.transition({"Direction": "in", "Destination": "Game"})
	randomize()
	
	print(GlobalVars.ingredient_data.keys())
	counters = [radial_shelf, bookshelf]
	cauldron.connect("check_recipe", self, "check_recipe")
	for i in range(6):
		deck.append(get_node("Counter/Countertop/VBoxContainer/HBoxContainer/Card%d" % i))
	draw_cards()
	display_recipes()


func draw_cards():
	for i in range(6):
		if i in GlobalVars.rolls:
			deck[i].enable()
			deck[i].show()
			
		else:
			deck[i].disable()
			deck[i].hide()

func check_recipe():
	var cur_recipe = []
	for i in GlobalVars.potion_ingredients:
		cur_recipe.append(i.ingredient_name)
	cur_recipe.sort()
	for item in GlobalVars.recipes:
		item[0].sort()
		if len(item[0]) == len(cur_recipe) and 'Philosophers Stone' in cur_recipe:
			var temp_cauldron = cur_recipe.duplicate()
			var temp_recipe = item[0].duplicate()
			var is_invalid = false
			for ingredient in item[0]:
				if ingredient in temp_cauldron:
					temp_cauldron.remove(temp_cauldron.find(ingredient))
					temp_recipe.remove(temp_recipe.find(ingredient))
			for ingredient in temp_recipe:
				if 'Potion' in ingredient:
					is_invalid = true
			if len(temp_cauldron) == 1 and 'Philosophers Stone' in temp_cauldron and not is_invalid:
				cur_recipe = item[0]
		if cur_recipe == item[0]:
			add_ingredient(item[1])
			if len(GlobalVars.potion_ingredients) > 1:
				for ingredient in GlobalVars.potion_ingredients:
						inventory_ingredients.remove(inventory_ingredients.find(ingredient))
						ingredient.queue_free()
				GlobalVars.potion_ingredients.clear()
			update_active_ingredient_display()


func _on_Game_tree_exiting():
	GlobalVars.save_to_disk()


func add_ingredient(ing_name):
	var cur_ing = pickable_ingredient.instance()
	inventory.add_child(cur_ing)
	inventory_ingredients.append(cur_ing)
	inventory_ingredients.sort()
	cur_ing.setup(ing_name)
	connect("mouse_exited_game_area", cur_ing, "drop_em")
	connect("reset_potion", cur_ing, "reset")
	cur_ing.connect("double_clicked", self, "_on_ingredient_pressed", [cur_ing.ingredient_name])
	cur_ing.connect("added_to_potion", self, "_on_add_to_potion", [cur_ing])


func _on_add_to_potion(ingredient):
	cauldron.poof.self_modulate = GlobalVars.ingredient_data[ingredient.ingredient_name]["color"]
	cauldron.poof.restart()
	cauldron.splash.restart()
	GlobalVars.potion_ingredients.append(ingredient)
	update_active_ingredient_display()

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
	var tmep = 170
	if move_direction == "right":
		# hey future me, maybe fix the position of this so it's not hard coded.
		tween.interpolate_property(counters[current_counter], "rect_position:x", 0, -tmep, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		current_counter = wrapi(current_counter + 1, 0, len(counters))
		tween.interpolate_property(counters[current_counter], "rect_position:x", tmep, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(counters[current_counter], "rect_position:x", 0, tmep, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		current_counter = wrapi(current_counter - 1, 0, len(counters))
		tween.interpolate_property(counters[current_counter], "rect_position:x", -tmep, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	for button in [left_button, right_button]:
		button.pressed = false
		button.toggle_mode = false
		button.toggle_mode = true


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
	update_active_ingredient_display()
	yield(get_tree().create_timer(0.9), "timeout")
	clear_button.pressed = false
	clear_button.toggle_mode = false
	clear_button.toggle_mode = true


func _on_HSlider_value_changed(value):
	GlobalVars.cauldron_temp = value
	cauldron.set_temp()


func _on_ingredient_pressed(ingredient):
	print(ingredient)


func update_active_ingredient_display():
	cauldron.update_ingredients()
	for item in range(16):
		var cur = get_node("Counter/Panel/GridContainer/DisplayButton%d" % item)
		if item < len(GlobalVars.potion_ingredients):
			cur.show()
			cur.setup(GlobalVars.potion_ingredients[item].ingredient_name)
		else:
			cur.hide()
		
func display_recipes():
	var output = ''
	for item in GlobalVars.recipes:
		for ing in item[0]:
			output += '[img]res://Art/Ingredients/%s.png[/img]' % ing
		output += '[img]res://Art/GUI/arrow_right_centered.png[/img][right][img]res://Art/Ingredients/%s.png[/img][/right]\n' % item[1]
	output += '\n\n\n\n'
	display_recipe.bbcode_text = output


func _on_Draw_Button_pressed():
	GlobalVars.draw_cards()
	if GlobalVars.hour < 11:
		GlobalVars.hour += 1
	else:
		GlobalVars.day += 1
		GlobalVars.hour = 0
		for card in deck:
			card.start_day()
	draw_cards()
