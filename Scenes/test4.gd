extends VBoxContainer



var recipe_icon = preload("res://Scenes/Recipe_Display.tscn")

func _ready():
	for item in GlobalVars.recipe_data:
		var fed_recipe = []
		for ing in GlobalVars.recipe_data[item]['Recipe']:
			fed_recipe.append(GlobalVars.ingredient_data.keys()[ing])
		add_recipe(fed_recipe)


func add_recipe(rec_ings):
	var new_recipe = recipe_icon.instance()
	new_recipe.set_textures([rec_ings, "Fianl_Potion_1"])
	add_child(new_recipe)
