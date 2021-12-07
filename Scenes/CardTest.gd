extends Panel



export var card_id = 0
onready var radial = get_node("VBoxContainer/Radial")
onready var hour_items = get_node("VBoxContainer/CenterContainer/ItemList")

signal add_from_list

var radial_button = preload("res://Scenes/Radial_Button.tscn")

var list_buttons = []

var aaaaaa = [
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


func _ready():
	radial.rad_vals = GlobalVars.radial_states[card_id]
	radial.setup(card_id)
	connect("add_from_list", owner, "add_ingredient")
	radial.connect("add_ingredient", owner, "add_ingredient")
	for i in range(12):
		for j in GlobalVars.states[i][card_id]:
			var cur_but = create_button(j)
			if GlobalVars.hour != i:
				cur_but.disable()


func create_button(button_name):
	var cur_button = radial_button.instance()
	cur_button.connect("pressed", self, "button_pressed", [cur_button])
	hour_items.add_child(cur_button)
	cur_button.setup(button_name)
	list_buttons.append(cur_button)
	return cur_button


func disable():
	for button in list_buttons:
		button.disable()
	radial.disable()


func button_pressed(button):
	print(button.sprite_name)
	disable()
	emit_signal("add_from_list", button.sprite_name)
	GlobalVars.rolls.remove(GlobalVars.rolls.find(card_id))
