extends Control

func _physics_process(delta):
	$TextureRect.rect_scale = $TextureRect.rect_scale + Vector2(0.1, 0.1)
