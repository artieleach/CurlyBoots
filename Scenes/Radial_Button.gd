extends TextureButton

onready var button_sprite = get_node("Button_Sprite")
onready var tween = get_node("Tween")
var sprite_name

func setup(button_name):
	sprite_name = button_name
	name = button_name
	get_node("Button_Sprite").texture = load("res://Art/Ingredients/%s.png" % button_name)
	get_node("Button_Sprite").scale = Vector2(0.2, 0.2)
	rect_min_size = Vector2(8, 8)


func _on_Radial_Button_mouse_entered():
	button_sprite.z_index = 10
	tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(1, 1), 0.2)
	tween.start()


func _on_Radial_Button_mouse_exited():
	button_sprite.z_index = 0
	tween.interpolate_property(button_sprite, "scale", button_sprite.scale, Vector2(0.2, 0.2), 0.2)
	tween.start()

func defocus():
	pass
