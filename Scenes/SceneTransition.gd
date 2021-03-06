extends Control

onready var tween = get_node("Tween")
onready var fader = get_node("Fader")
var cur_trans: Dictionary = {"Direction": "in", "Destination": "game"}

func transition(trans_type):
	show()
	cur_trans = trans_type
	if trans_type["Direction"] == "out":
		tween.interpolate_property(fader, "modulate:a", 0.0, 1.0, 0.75)
	else:
		tween.interpolate_property(fader, "modulate:a", 1.0, 0.0, 0.6)
	tween.start()


func _on_Tween_tween_completed(object, _key):
	if object == fader:
		hide()
		transition_finished()


func transition_finished():
	if cur_trans["Direction"] == 'out':
		if cur_trans["Destination"] == "Game":
			get_tree().change_scene("res://Scenes/Game.tscn")
		elif cur_trans["Destination"] == "Credits":
			get_tree().change_scene("res://assets/credits.tscn")
		elif cur_trans["Destination"] == "Menu":
			get_tree().change_scene("res://Scenes/Menu.tscn")
		elif cur_trans["Destination"] == "Options":
			#get_tree().change_scene("res://assets/Menu.tscn")
			pass
	get_tree().paused = false
