extends TextureButton

signal clicked

func _ready():
	connect("clicked", owner, "_on_%s_pressed" % name)
	$Button_Sprite/Label.text = name
	$Button_Sprite.flip_h = bool(randi() % 2)


func _on_ScrollButton_pressed():
	$Tween.interpolate_property($Button_Sprite, "position:x", 0, 62, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	AudioHolder.play_audio("bookFlip2", -20)


func _on_Tween_tween_completed(_object, _key):
	emit_signal("clicked")
