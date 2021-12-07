extends TextureButton

onready var button_sprite = get_node("Button_Sprite")
onready var tween = get_node("Tween")
onready var label = get_node("Button_Sprite/Label")
var sprite_name = ''
var is_active = true
var hovered = false
export var displays_label = true


func _ready():
	get_node("Button_Sprite").scale = Vector2(0.2, 0.2)
	rect_min_size = Vector2(8, 8)
	label.hide()

func setup(button_name):
	sprite_name = button_name
	label.text = sprite_name
	get_node("Button_Sprite").texture = load("res://Art/Ingredients/%s.png" % button_name)


func _on_Radial_Button_mouse_entered():
	hovered = true
	if is_active:
		button_sprite.z_index = 10
		tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(1, 1), 0.2)
		tween.start()
		yield(get_tree().create_timer(0.2), "timeout")
		if hovered:
			if displays_label:
				label.show()
		


func _on_Radial_Button_mouse_exited():
	hovered = false
	if is_active:
		tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(0.2, 0.2), 0.2)
		tween.start()
		label.hide()
		yield(get_tree().create_timer(0.2), "timeout")
		if not hovered:
			button_sprite.z_index = 0


func disable():
	_on_Radial_Button_mouse_exited()
	mouse_filter = MOUSE_FILTER_IGNORE
	modulate = Color(0, 0, 0, 0.5)
	is_active = false

func enable():
	_on_Radial_Button_mouse_exited()
	mouse_filter = MOUSE_FILTER_PASS
	modulate = Color(1, 1, 1, 1)
	is_active = true
