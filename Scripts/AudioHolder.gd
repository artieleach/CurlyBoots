extends Node

var sfx = {}
var songs = {}
var players = []
var music_player

func _ready():
	for _i in range(12):
		var new_player = AudioStreamPlayer.new()
		add_child(new_player)
		players.append(new_player)
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	dir_contents("res://Audio/Sounds/", sfx)
	dir_contents("res://Audio/Songs/", songs)
	update_volume()


func update_volume():
	for item in players:
		if not GlobalVars.sound:
			item.bus = "Master"
		else:
			item.bus = "Mute"


func dir_contents(path, type):
	var names = []
	var values = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".wav") or file_name.ends_with('.ogg'):
				names.append(file_name.split('.')[0])
				values.append(load(path + file_name))
			file_name = dir.get_next()
	else:
		print("artie you fucking HACK something went wrong. probably a permission thing? anyway if anyone except me sees this, publicly tell me to increase my shame.")
	for item in len(names):
		type[names[item]] = values[item]


func play_audio(sound: String, vol=0, pitch_scale=1):
	var target
	for player in players:
		if not player.playing:
			target = player
			break
	if sound in sfx:
		target.stream = sfx[sound]
		target.volume_db = vol
		target.pitch_scale = pitch_scale
		target.play()
		return target
	else:
		pass
		#print('failed to play: %s' % sound)


func pause_audio(player):
	player.playing = false
	player.stream = null


func play_song(song: String, vol=0):
	if song in songs:
		music_player.stream = songs[song]
		music_player.volume_db = vol
		music_player.play()
	else:
		print('failed to play: %s' % song)
