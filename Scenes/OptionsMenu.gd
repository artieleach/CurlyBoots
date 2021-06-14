extends Control

onready var menu = get_node("Book/VBoxContainer/Menu")
onready var music = get_node("Book/VBoxContainer/Music")
onready var sound = get_node("Book/VBoxContainer/Sound")
onready var tween = get_node("Tween")
onready var book = get_node("Book")

signal button_toggled
var button_pressed
var offset = -224

func _ready():
	music.pressed = GlobalVars.music
	sound.pressed = GlobalVars.sound
	if GlobalVars.music:
		music.modulate = Color("8b93af")
	else:
		music.modulate = Color("141013")
	if GlobalVars.sound:
		sound.modulate = Color("8b93af")
	else:
		sound.modulate = Color("141013")
	menu.modulate = Color("141013")
	
	

func slide():
	if book.position.x == offset:
		show()
		AudioHolder.play_audio("bookSlide")
		tween.interpolate_property(book, "position:x", book.position.x, -160, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	else:
		AudioHolder.play_audio("bookSlide")
		tween.interpolate_property(book, "position:x", book.position.x, offset, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	if book.position.x == offset:
		get_tree().paused = false
		hide()


func _on_Sound_pressed():
	GlobalVars.sound = not GlobalVars.sound
	AudioHolder.update_volume()
	if GlobalVars.sound:
		sound.modulate = Color("8b93af")
	else:
		sound.modulate = Color("141013")


func _on_Music_pressed():
	GlobalVars.music = not GlobalVars.music
	AudioHolder.music_player.stream_paused = GlobalVars.music
	if GlobalVars.music:
		music.modulate = Color("8b93af")
	else:
		music.modulate = Color("141013")



func _on_Menu_pressed():
	SceneTransition.transition({"Direction": "out", "Destination": "Menu"})



func _on_OptionsMenu_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		slide()
