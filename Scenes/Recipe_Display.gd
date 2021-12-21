extends TextureButton

export var recipe_name = ''


func set_textures(recipe):
	print(recipe)
	for item in range(len(recipe[0])):
		get_node("HBoxContainer/Page%s" % item).show()
		get_node("HBoxContainer/Page%s/CenterContainer/Sprite" % item).texture = load("res://Art/Ingredients/%s.png" % recipe[0][item])
		
	get_node("HBoxContainer/Final/CenterContainer/Sprite").texture = load("res://Art/Ingredients/%s.png" % recipe[1])



func _on_Recipe_Display_pressed():
	print('ere')
	pass # Replace with function body.

