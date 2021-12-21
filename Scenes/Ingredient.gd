extends TextureButton

onready var ingredient_sprite = get_node("Node2D/Ingredient_Sprite")
onready var holder = get_node("holder")
onready var tween = get_node("Tween")
onready var drawing = get_node("Node2D")
onready var label = get_node("Node2D/Ingredient_Sprite/Label")

var held: bool = false
var offset: Vector2 = Vector2(0, 0)
var will_open_help: bool = false
var ingredient_effects
var pickable: bool = true
var hovering_over_cauldron: bool = false
export var ingredient_name = ''
signal double_clicked
signal added_to_potion
var hovered = false
var in_potion = false


func setup(ing_name):
	ingredient_name = ing_name
	label.text = ingredient_name
	texture_normal = null
	add_to_group("ingredients")
	ingredient_sprite.texture = load("res://Art/Ingredients/%s.png" % ingredient_name)
	holder.texture = load("res://Art/Ingredients/%s.png" % ingredient_name)
	rect_min_size = Vector2(8, 8)
	ingredient_sprite.show()
	label.hide()


func _process(_delta):
	if held:
		tween.interpolate_property(drawing, "global_position", drawing.global_position, get_global_mouse_position() - offset, 0.09)
		tween.start()
		drawing.global_position = Vector2(drawing.global_position / 5).floor() * 5


func _on_ingredient_mouse_exited():
	ingredient_sprite.use_parent_material = true
	label.hide()
	will_open_help = true


func reset():
	ingredient_sprite.use_parent_material = true
	drawing.z_index = 0
	drawing.position = Vector2(0, 0)
	offset = Vector2(0, 0)
	tween.interpolate_property(drawing, "self_modulate:a",0 ,1, .8)
	tween.start()
	ingredient_sprite.show()
	pickable = true
	held = false
	will_open_help = false
	ingredient_sprite.scale = Vector2(0.4, 0.4)


func go_back():
	offset = Vector2(0, 0)
	tween.interpolate_property(drawing, "position", drawing.position, Vector2(0, 0), 0.5, Tween.TRANS_CUBIC)
	tween.interpolate_property(drawing, "z_index", drawing.z_index, 0, 0.5)
	tween.start()


func pick_up():
	held = true
	drawing.z_index = 5
	tween.interpolate_property(self, "offset", offset, Vector2(2, 2), 0.02, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	AudioHolder.play_audio("pick%s" % name, -5)


func add_to_potion():
	drawing.z_index = 2
	in_potion = true
	tween.interpolate_property(drawing, "global_position", drawing.global_position, Vector2(clamp(drawing.global_position.x, 900, 1000), 600), 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(0.4), "timeout")
	AudioHolder.play_audio('magic_00%d' % (randi() % 9 + 1), -10)
	emit_signal("added_to_potion")
	ingredient_sprite.hide()


func deactivate():
	pickable = false

func activate():
	pickable = true

func mouse_hover():
	if pickable:
		label.show()
		if hovered:
			tween.interpolate_property(label, "self_modulate:a", 0, 1, 0.2, Tween.TRANS_EXPO, Tween.EASE_IN)
			tween.start()
		ingredient_sprite.use_parent_material = false


func generate_page():
	var output = ''
	output += '[]'
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			hide()
			emit_signal("double_clicked")
			yield(get_tree().create_timer(0.2), "timeout")
			show()
		elif event.button_index == BUTTON_LEFT:
			if event.pressed:
				if pickable:
					ingredient_sprite.use_parent_material = true
					offset = event.global_position 
					pick_up()
			else:
				held = false
				if get_global_mouse_position().x > 900 and 1100 > get_global_mouse_position().x and pickable:
					pickable = false
					add_to_potion()
				else:
					go_back()
	if event is InputEventMouseMotion:
		if held:
			pass
		else:
			mouse_hover()


func _on_reset_ingredients():
	if not visible:
		reset()


func _on_Ingredient_mouse_exited():
	
	ingredient_sprite.z_index = 0
	hovered = false
	label.hide()
	ingredient_sprite.use_parent_material = true
	will_open_help = true
	if pickable:
		tween.interpolate_property(ingredient_sprite, "scale", ingredient_sprite.scale, Vector2(0.4, 0.4), 0.2)
		tween.start()



func drop_em():
	if held:
		held = false
		go_back()




func _on_Ingredient_mouse_entered():
	ingredient_sprite.z_index = 1000
	hovered = true
	if pickable:
		tween.interpolate_property(ingredient_sprite, "scale", ingredient_sprite.scale, Vector2(1, 1), 0.2)
		tween.start()



