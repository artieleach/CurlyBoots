extends TextureButton

onready var spine = get_node("Spine")

signal selected

func _ready():
	spine.texture = texture_normal
	connect("selected", owner, "_on_book_pressed", [name])

func _on_Book_mouse_entered():
	spine.use_parent_material = false


func _on_Book_mouse_exited():
	spine.use_parent_material = true


func _on_Book_pressed():
	emit_signal("selected")
