extends Control

var sound = false
var music = false
var bg_player


func _ready():
	AudioHolder.play_song("mesmerize-by-kevin-macleod-from-filmmusic-io")
	SceneTransition.transition({"Direction": "in", "Destination": "Menu"})


func _on_Credits_pressed():
	AudioHolder.pause_audio(AudioHolder.music_player)
	SceneTransition.transition({"Direction": "out", "Destination": "Credits"})


func _on_Options_pressed():
	AudioHolder.pause_audio(AudioHolder.music_player)
	SceneTransition.transition({"Direction": "out", "Destination": "Options"})


func _on_Play_pressed():
	AudioHolder.pause_audio(AudioHolder.music_player)
	SceneTransition.transition({"Direction": "out", "Destination": "Game"})
