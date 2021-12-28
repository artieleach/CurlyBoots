extends TextureButton

export var recipe_name = ''

onready var panel = get_node("Panel")

var selected = false

func _ready():
	panel.rect_size = get_node("Panel/CenterContainer/HBoxContainer").rect_size
	panel.self_modulate = Color(0, 0, 0)

func set_textures(recipe):
	print(recipe)
	for item in range(len(recipe[0])):
		get_node("Panel/CenterContainer/HBoxContainer/Page%s" % item).self_modulate = Color(1, 1, 1)
		get_node("Panel/CenterContainer/HBoxContainer/Page%s/CenterContainer/Sprite" % item).texture = load("res://Art/Ingredients/%s.png" % recipe[0][item])
	get_node("Panel/CenterContainer/HBoxContainer/Final/CenterContainer/Sprite").texture = load("res://Art/Ingredients/%s.png" % recipe[1])



func _on_Recipe_Display_pressed():
	print(recipe_name)



func _on_Panel_mouse_entered():
	panel.self_modulate = Color(150, 150, 150)


func _on_Panel_mouse_exited():
	panel.self_modulate = Color(0, 0, 0)


func _on_Panel_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		selected = true
