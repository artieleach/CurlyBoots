extends Panel

export var card_id = 0

signal add_ingredient

var list_ingredients = []
var radial_ingredients = []
var all_ingredients = []

onready var radial = get_node("VBoxContainer/Radial")
onready var itemlist = get_node("VBoxContainer/CenterContainer/ItemList")
onready var tween = get_node("Tween")

var highlighted_ingredient = null
var radius = 9
var radial_button = preload("res://Scenes/Radial_Button.tscn")

func _ready():
	connect("add_ingredient", owner, "add_ingredient")
	set_list()
	set_radial()
	

func set_list():
	for i in range(12):
		for j in GlobalVars.states[i][card_id]:
			var cur = create_ingredient(j, itemlist)
			list_ingredients.append(cur)
			all_ingredients.append(cur)
			if GlobalVars.hour != i:
				cur.disable()


func set_radial():
	for i in range(len(GlobalVars.radial_states[card_id])):
		var cur = create_ingredient(GlobalVars.radial_states[card_id][i], radial)
		radial_ingredients.append(cur)
		all_ingredients.append(cur)
	update_radial(true)


func update_radial(instant=false):
	if len(radial_ingredients) > 1:
		for i in range(len(radial_ingredients)):
			var angle = 360 / len(radial_ingredients) * i
			var cur = radial_ingredients[i]
			var new_pos = Vector2(
				12 + radius * cos(angle * PI / 180), 
				8 +  radius * sin(angle * PI / 180))
			if not instant:
				tween.interpolate_property(cur, "rect_position", cur.rect_position, new_pos, 0.3)
				tween.start()
			else:
				cur.rect_position = new_pos


func create_ingredient(ing_name, ing_owner):
	var cur = radial_button.instance()
	cur.connect("pressed", self, "ingredient_pressed", [cur])
	cur.connect("mouse_entered", self, "bring_to_front", [cur])
	cur.connect("mouse_exited", self, "reset_buttons")
	ing_owner.add_child(cur)
	cur.setup(ing_name)
	return cur


func ingredient_pressed(ingredient):
	print(ingredient.sprite_name)
	emit_signal("add_ingredient", ingredient.sprite_name)
	if radial_ingredients.find(ingredient) != -1:
		radial_ingredients.remove(radial_ingredients.find(ingredient))
	ingredient.hide()
	GlobalVars.rolls.remove(GlobalVars.rolls.find(card_id))
	disable()


func disable():
	for ingredient in all_ingredients:
		ingredient.disable()

func bring_to_front(ingredient):
	highlighted_ingredient = ingredient
	if ingredient.visible and ingredient.is_active:
		for item in all_ingredients:
			if item.is_active and item != ingredient:
				tween.interpolate_property(item, "modulate", item.modulate, Color(0.8, 0.8, 0.8, 1), 0.3)
		tween.start()
		ingredient.modulate = Color(1, 1, 1, 1)
		
		yield(get_tree().create_timer(0.3), "timeout")
		if highlighted_ingredient == null:
			reset_buttons()


func reset_buttons():
	highlighted_ingredient = null
	for item in all_ingredients:
		if item.is_active:
			tween.interpolate_property(item, "modulate", item.modulate, Color(1, 1, 1, 1), 0.2)
	tween.start()

