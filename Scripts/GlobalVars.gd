extends Node

var scheduled_customers = []
var potion_balance = [1, 1, 1, 1]
var potion_ingredients = []
var day = 0
var hour = 0
var sound = false
var music = false
var time_left = 0
var forbidden_items = []
var cards = ["this, that"]
var debug = false
var cauldron_color = Color('#000000')
var ingredient_data
var recipe_data
var cauldron_temp = 0
var scale = 8

var possilbe_rolls = [0, 1, 2, 3, 4, 5]
const POTION_VARS = ['A', 'B', 'C', 'D']
var rolls = []

var radial_states = [
 ["0", "1", "2", "3", "4", "5"], 
 ["0", "1", "2", "3", "4", "5"], 
 ["0", "1", "2", "3", "4", "5"], 
 ["0", "1", "2", "3", "4", "5"], 
 ["0", "1", "2", "3", "4", "5"], 
 ["0", "1", "2", "3", "4", "5"], 
]

var states = [
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 [["0"], ["1"], ["2"], ["3"], ["4"], ["5"], ["6"], ["7"], ["8"], ["9"], ["10"], ["11"]], 
 ]

func _init():
	debug = false
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		save_to_disk()
	ingredient_data = get_json("res://Writing/ingredient_data")
	recipe_data = get_json("res://Writing/recipe_data")
	load_game()
	randomize()
	draw_cards()


func draw_cards():
	possilbe_rolls.shuffle()
	rolls = [possilbe_rolls[0], possilbe_rolls[1], possilbe_rolls[2]]
	

func get_json(file_string):
	var cur_file = File.new()
	cur_file.open("%s.json" % file_string, cur_file.READ)
	var json = cur_file.get_as_text()
	var result = JSON.parse(json).result
	cur_file.close()
	return result



func save():
	var save_dict = {
		"scheduled_customers": scheduled_customers,
		"day": day,
		"sound": sound,
		"music": music,
		"forbidden_items": forbidden_items,
		"debug": debug,
	}
	return save_dict


func save_to_disk():
	print('saving...')
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(save()))
	save_game.close()
	print('saved')


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	save_game.open("user://savegame.save", File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		for i in node_data.keys():
			set(i, node_data[i])
	save_game.close()
