extends Control

onready var cauldron = get_node("Counter/Cauldron")
onready var dialog
onready var day_summary = get_node("Day_Summary")
onready var options_menu = get_node("OptionsMenu")
onready var tween = get_node("Tween")
onready var schedule

signal mouse_exited_game_area


func _ready():
	SceneTransition.transition({"Direction": "in", "Destination": "Game"})
	randomize()


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
	print(GlobalVars.potion_balance)
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
	schedule = ['no one']
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
	GlobalVars.cauldron_temp += 1
	cauldron.set_temp()
	print(GlobalVars.cauldron_temp)


func _on_Left_Button_pressed():
	if GlobalVars.cauldron_temp > 1:
		GlobalVars.cauldron_temp -= 1
	cauldron.set_temp()
	print(GlobalVars.cauldron_temp)


func _on_Game_mouse_exited():
	emit_signal("mouse_exited_game_area")
