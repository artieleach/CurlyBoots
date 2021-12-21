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

var possilbe_rolls = [0, 1, 2, 3, 4, 5]
const POTION_VARS = ['A', 'B', 'C', 'D']
var rolls = []

var recipes = [
 [["Airtek Claw", "Dobberchu Tongue"], "Potion 1"],
 [["Airtek Claw", "Dobberchu Tongue", "Dobberchu Tongue"], "Potion 2"],
 [["Merrow Heart", "Muckshroom"], "Potion 3"],
 [["Merrow Heart", "Ollifeist Tentacle"], "Potion 3"],
 [["Airtek Claw", "Begonea Scale", "Foxglove"], "Potion 4"], 
 [["Airtek Claw", "Muckshroom", "Ollifeist Tentacle"], "Potion 5"], 
 [["Foxglove", "Philosophers Stone", "Potion 1"], "Potion 6"],
 [["Begonea Scale"], "Fianl_Potion_1"],
 [["Silver Silin", "Philosophers Stone"], "Fianl_Potion_2"],
 [["Merrow Heart", "Muckshroom", "Ollifeist Tentacle"], "Fianl_Potion_3"],  # need to figure out doubles!
 [["Potion 4"], "Fianl_Potion_4"],
 [["Muckshroom", "Ollifeist Tentacle", "Phomarian Hand"], "Fianl_Potion_5"],
 [["Tendroot", "Potion 6"], "Fianl_Potion_6"],
 [["Herbdew", "Glasdig Horn", "Potion 4"], "Fianl_Potion_7"],
 [["Begonea Scale", "Foxglove", "Herbdew", "Mandrake", "Potion 1"], "Fianl_Potion_8"],
 [["Potion 2", "Potion 3", "Potion 6"], "Fianl_Potion_9"],
 [["Phomarian Hand", "Silver Silin", "Potion 4", "Potion 5"], "Fianl_Potion_10"],
 [["Muckshroom", "Ollifeist Tentacle", "Tendroot", "Potion 3", "Potion 4"], "Fianl_Potion_11"],
 [["Potion 2", "Potion 4", "Potion 5"], "Fianl_Potion_12"]
]
var radial_states = [
 ["Begonea Scale", "Begonea Scale", "Begonea Scale", "Begonea Scale", "Foxglove", "Dobberchu Tongue", "Airtek Claw", "Mandrake"], 
 ["Dobberchu Tongue", "Airtek Claw", "Merrow Heart", "Airtek Claw", "Dobberchu Tongue", "Foxglove"],
 ["Foxglove", "Foxglove", "Foxglove", "Dobberchu Tongue", "Herbdew", "Airtek Claw", "Glasdig Horn"],
 ["Herbdew", "Glasdig Horn", "Mandrake", "Foxglove", "Begonea Scale", "Philosophers Stone"],
 ["Merrow Heart", "Phomarian Hand", "Muckshroom", "Philosophers Stone", "Merrow Heart", "Phomarian Hand", "Muckshroom", "Ollifeist Tentacle"],
 ["Philosophers Stone", "Begonea Scale", "Philosophers Stone", "Silver Silin", "Philosophers Stone", "Tendroot"]
]

var states = [
 [["Merrow Heart"], ["Dobberchu Tongue"],  ["Muckshroom", "Silver Silin"], ["Ollifeist Tentacle"],  ["Begonea Scale"],  ["Potion 1"]],
 [["Ollifeist Tentacle"], ["Begonea Scale", "Herbdew"],  ["Airtek Claw"],  ["Merrow Heart"],  ["Philosophers Stone"],  ["Muckshroom"]],
 [["Potion 3"], ["Tendroot"],  ["Merrow Heart", "Herbdew"],  ["Begonea Scale"],  ["Dobberchu Tongue"],  ["Silver Silin"]],
 [["Philosophers Stone"], ["Phomarian Hand", "Muckshroom"], ["Airtek Claw"],  ["Potion 2"],  ["Herbdew"],  ["Merrow Heart"]],
 [["Muckshroom"], ["Ollifeist Tentacle"],  ["Merrow Heart"],  ["Silver Silin"],  ["Phomarian Hand", "Tendroot"], ["Potion 1"]],
 [["Philosophers Stone"], ["Begonea Scale"],  ["Potion 2"],  ["Merrow Heart", "Glasdig Horn"],  ["Airtek Claw"],  ["Ollifeist Tentacle"]],
 [["Potion 1"], ["Tendroot"],  ["Ollifeist Tentacle"],  ["Mandrake", "Phomarian Hand"], ["Dobberchu Tongue"],  ["Potion 3"]],
 [["Airtek Claw"], ["Potion 6"],  ["Glasdig Horn"],  ["Foxglove"],  ["Ollifeist Tentacle"],  ["Potion 4"]],
 [["Potion 2"], ["Philosophers Stone"],  ["Muckshroom"],  ["Potion 5"],  ["Ollifeist Tentacle", "Tendroot"], ["Dobberchu Tongue"]],
 [["Potion 6"], ["Airtek Claw"],  ["Silver Silin"],  ["Muckshroom"],  ["Potion 4"],  ["Begonea Scale"]],
 [["Potion 5"], ["Herbdew"],  ["Phomarian Hand"],  ["Mandrake"],  ["Philosophers Stone"],  ["Potion 2"]],
 [["Tendroot"], ["Silver Silin"],  ["Philosophers Stone"],  ["Dobberchu Tongue"],  ["Potion 3"],  ["Potion 4"]]
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
