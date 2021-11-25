extends TextureButton

onready var button_sprite = get_node("Button_Sprite")
onready var tween = get_node("Tween")
onready var label = get_node("Button_Sprite/Label")
var sprite_name
var is_active = true
var hovered = false

func setup(button_name):
	sprite_name = button_name
	label.hide()
	label.text = sprite_name
	name = button_name
	get_node("Button_Sprite").texture = load("res://Art/Ingredients/%s.png" % button_name)
	get_node("Button_Sprite").scale = Vector2(0.2, 0.2)
	rect_min_size = Vector2(8, 8)


func _on_Radial_Button_mouse_entered():
	hovered = true
	if is_active:
		button_sprite.z_index = 10
		tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(1, 1), 0.2)
		tween.start()
		yield(tween, "tween_completed")
		if hovered:
			tween.interpolate_property(label, "self_modulate:a", 0, 1, 0.2, Tween.TRANS_EXPO, Tween.EASE_IN)
			tween.start()
			label.show()
		


func _on_Radial_Button_mouse_exited():
	hovered = false
	if is_active:
		button_sprite.z_index = 0
		tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(0.2, 0.2), 0.2)
		tween.start()
		label.hide()

func disable():
	mouse_filter = MOUSE_FILTER_IGNORE
	self_modulate = Color(0, 0, 0, 0.5)
	is_active = false
