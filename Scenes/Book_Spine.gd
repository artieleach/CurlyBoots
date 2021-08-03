extends TextureButton

onready var spine = get_node("Spine")


func _ready():
	spine.texture = texture_normal

func _on_Book_mouse_entered():
	spine.use_parent_material = false


func _on_Book_mouse_exited():
	spine.use_parent_material = true
