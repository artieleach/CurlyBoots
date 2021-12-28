extends VBoxContainer

var recipe_icon = preload("res://Scenes/Recipe_Display.tscn")


func _ready():
	for item in GlobalVars.recipe_data:
		var new_recipe = recipe_icon.instance()
		new_recipe.set_textures([GlobalVars.recipe_data[item]['recipe'], GlobalVars.recipe_data[item]['return']])
		new_recipe.recipe_name = str(randi() % 1000)
		add_child(new_recipe)
