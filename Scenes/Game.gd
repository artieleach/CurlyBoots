extends Node2D

onready var cauldron = get_node("Counter/ViewportContainer/Viewport/Cauldron")
onready var dialog
onready var day_summary = get_node("Day_Summary")
onready var options_menu = get_node("OptionsMenu")
onready var tween = get_node("Tween")
onready var schedule
onready var bookshelf = get_node("Counter/Bookshelf")
onready var ingredient_shelf = get_node("Counter/Countertop")
onready var book = get_node("Book")
onready var left_button = get_node("Counter/Left_Button")
onready var right_button = get_node("Counter/Right_Button")
onready var clear_button = get_node("Counter/Countertop/Clear_Button")
onready var full_cauldron = get_node("Counter/full_cauldron")

var counters

signal mouse_exited_game_area
signal clear_recent
signal deactivate

var current_counter = 0

func _ready():
	SceneTransition.transition({"Direction": "in", "Destination": "Game"})
	randomize()
	counters = [ingredient_shelf, bookshelf]


func _on_Game_tree_exiting():
	GlobalVars.save_to_disk()


func calculate_metric(ingredient, cur_state):
	var new_state = [0, 0, 0, 0]
	for i in range(len(cur_state)):
		new_state[i] = clamp(cur_state[i] + GlobalVars.ingredient_data[ingredient]["features"][i], 0, 2)
	return new_state


func _on_add_to_potion(ingredient):
	cauldron.poof.self_modulate = GlobalVars.ingredient_data[ingredient]["color"]
	cauldron.poof.restart()
	cauldron.splash.restart()
	GlobalVars.potion_ingredients.append(ingredient)
	var old = GlobalVars.potion_balance
	GlobalVars.potion_balance = calculate_metric(ingredient, GlobalVars.potion_balance)
	emit_signal("clear_recent")
	yield(get_tree().create_timer(0.9), "timeout")
	cauldron.set_indicators(false, old)


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
	if current_counter < 1:
		current_counter += 1
	else:
		current_counter = 0
	update_counter("right")


func _on_Left_Button_pressed():
	if current_counter > 0:
		current_counter -= 1
	else:
		current_counter = 1
	update_counter("left")


func update_counter(move_direction):
	if move_direction == "right":
		# hey future me, maybe fix the position of this so it's not hard coded.
		tween.interpolate_property(counters[current_counter], "rect_position:x", 160, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(counters[current_counter-1], "rect_position:x", 0, -160, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(counters[current_counter], "rect_position:x", -160, 0, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.interpolate_property(counters[current_counter-1], "rect_position:x", 0, 160, 0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
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
	GlobalVars.potion_ingredients.clear()
	var old = GlobalVars.potion_balance
	GlobalVars.potion_balance = [1, 1, 1, 1]
	cauldron.set_indicators(false, old)
	emit_signal("clear_recent")
	yield(get_tree().create_timer(0.9), "timeout")
	clear_button.pressed = false
	clear_button.toggle_mode = false
	clear_button.toggle_mode = true


func _on_HSlider_value_changed(value):
	GlobalVars.cauldron_temp = value
	cauldron.set_temp()
