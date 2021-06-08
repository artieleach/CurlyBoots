extends Control

onready var menu = get_node("Book/VBoxContainer/Menu")
onready var music = get_node("Book/VBoxContainer/Music")
onready var sound = get_node("Book/VBoxContainer/Sound")

signal button_toggled
var button_pressed
var offset = -224

func _ready():
	yield(owner, "ready")
	connect("button_toggled", owner, "_on_button_toggled")
	music.pressed = GlobalVars.music
	sound.pressed = GlobalVars.sound
	

func slide():
	if $Book.position.x == offset:
		show()
		AudioHolder.play_audio("bookSlide")
		$Tween.interpolate_property($Book, "position:x", $Book.position.x, -160, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	else:
		AudioHolder.play_audio("bookSlide")
		$Tween.interpolate_property($Book, "position:x", $Book.position.x, offset, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_completed")
	if $Book.position.x == offset:
		get_tree().paused = false
		hide()


func _on_Optionsmenu_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		slide()


func _on_Sound_pressed():
	if sound.pressed:
		sound.modulate = Color("8b93af")
	else:
		sound.modulate = Color("141013")
	emit_signal("button_toggled", "sound")


func _on_Music_pressed():
	if music.pressed:
		music.modulate = Color("8b93af")
	else:
		music.modulate = Color("141013")
	emit_signal("button_toggled", "music")


func _on_Menu_pressed():
	emit_signal("button_toggled", "menu")
	slide()

