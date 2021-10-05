extends TextureButton

onready var ingredient_sprite = get_node("Node2D/Ingredient_Sprite")
onready var indicators = get_node("Node2D/Indicators")
onready var tween = get_node("Tween")
onready var drawing = get_node("Node2D")

var held: bool = false
var offset: Vector2 = Vector2(0, 0)
var will_open_help: bool = false
var ingredient_effects
var pickable: bool = true
var hovering_over_cauldron: bool = false
var my_width = 0
signal double_clicked
signal added_to_potion


func _ready():
	yield(owner, "ready")
	texture_normal = null
	add_to_group("ingredient")
	connect("double_clicked", owner, "_on_ingredient_pressed", [name])
	connect("added_to_potion", owner, "_on_add_to_potion", [name])
	owner.connect("mouse_exited_game_area", self, "drop_em")
	owner.connect("clear_recent", self, "decide_usable")
	decide_usable()
	ingredient_sprite.texture = load("res://Art/Ingredients/%s.png" % name)
	my_width = ingredient_sprite.texture.get_width()
	rect_size = ingredient_sprite.texture.get_size()
	indicators.rect_size = rect_size
	ingredient_sprite.show()
	for i in range(len(GlobalVars.potion_balance)):
		indicators.get_node("%s/AnimatedSprite" % GlobalVars.POTION_VARS[i]).frame = GlobalVars.ingredient_data[name]["features"][i] + 1


func _process(_delta):
	if held:
		tween.interpolate_property(drawing, "global_position", drawing.global_position, get_global_mouse_position() - offset, 0.09)
		tween.start()
		drawing.global_position = Vector2(drawing.global_position / 5).floor() * 5


func _on_ingredient_mouse_exited():
	ingredient_sprite.use_parent_material = true
	will_open_help = true
	indicators.hide()


func reset():
	ingredient_sprite.use_parent_material = true
	ingredient_sprite.self_modulate = Color(1, 1, 1)
	drawing.z_index = 0
	tween.interpolate_property(drawing, "position", Vector2(0, -100), Vector2(0, 0), 1.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	show()
	held = false
	will_open_help = false
	indicators.hide()
	offset = Vector2(0, 0)


func go_back():
	ingredient_sprite.self_modulate = Color(1, 1, 1)
	indicators.hide()
	offset = Vector2(0, 0)
	tween.interpolate_property(drawing, "position", drawing.position, Vector2(0, 0), 0.5, Tween.TRANS_CUBIC)
	tween.interpolate_property(drawing, "z_index", drawing.z_index, 0, 0.5)
	tween.start()


func pick_up():
	ingredient_sprite.self_modulate = Color(1, 1, 1)
	held = true
	drawing.z_index = 5
	tween.interpolate_property(self, "offset", offset, Vector2(60, 60), 0.02, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	AudioHolder.play_audio("pick%s" % name, -5)


func add_to_potion():
	ingredient_sprite.self_modulate = Color(1, 1, 1)
	indicators.hide()
	drawing.z_index = 2
	tween.interpolate_property(drawing, "position:y", drawing.position.y, 50, 0.5, Tween.TRANS_SINE, Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(0.4), "timeout")
	AudioHolder.play_audio('magic_00%d' % (randi() % 9 + 1), -10)
	emit_signal("added_to_potion")
	reset()
	deactivate()


func deactivate():
	pickable = false
	ingredient_sprite.modulate = Color(0.5, 0.5, 0.5)
	indicators.hide()

func activate():
	ingredient_sprite.modulate = Color(1.0, 1.0, 1.0)
	pickable = true

func mouse_hover():
	if pickable:
		ingredient_sprite.use_parent_material = false
	indicators.show()


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
				indicators.hide()
				held = false
				if get_global_mouse_position().x > 920:
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
	ingredient_sprite.use_parent_material = true
	will_open_help = true
	indicators.hide()


func drop_em():
	if held:
		held = false
		go_back()



func decide_usable():
	deactivate()
	var count = [0, 0, 0]
	for i in GlobalVars.potion_balance:
		count[i] = count[i] + 1
	print(count)
	match name:
		'Airtek Claw':
			if count[2] == 2:
				activate()
		'Tendroot':
			if  count[0] == 2:
				activate()
		'Begonea':
			if count[0] == 0:
				activate()
		'Dobberchu Tongue':
			if count[1] != 0:
				activate()
		'Foxglove':
			if count[2] > count[0]:
				activate()
		'Tuathaw Ear':
			if count[0] > count[2]:
				activate()
		'Herbdew':
			var hit = false
			for item in range(3):
				if GlobalVars.potion_balance[item] == GlobalVars.potion_balance[item + 1]:
					hit = true
			if hit == false:
				activate()
		'Mandrake':
			var hit = false
			for item in range(3):
				if GlobalVars.potion_balance[item] == GlobalVars.potion_balance[item + 1]:
					hit = true
			if hit:
				activate()
		'Merrow Heart':
			if GlobalVars.potion_balance[0] == GlobalVars.potion_balance[3]:
				activate()
		'Muckshroom':
			if GlobalVars.potion_balance[0] != GlobalVars.potion_balance[3]:
				activate()
		'Ollifeist Tentacle':
			var hit = false
			for item in range(3):
				if GlobalVars.potion_balance[item] == 1 and GlobalVars.potion_balance[item+1] != 1:
					hit = true
			if hit:
				activate()
		'Phomarian Hand':
			var hit = false
			for item in range(3):
				if GlobalVars.potion_balance[item] == 0 and GlobalVars.potion_balance[item+1] != 0:
					hit = true
			if hit == true:
				activate()
		'Silver Silin':
			var hit = false
			for item in range(3):
				if GlobalVars.potion_balance[item] == 2 and GlobalVars.potion_balance[item+1] != 2:
					hit = true
			if hit == true:
				activate()
		_:
			print(name)
