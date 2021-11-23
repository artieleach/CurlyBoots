extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var radial_button = preload("res://Scenes/Radial_Button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(20):
		var new_item = radial_button.instance()
		new_item.setup(GlobalVars.ingredient_data.keys()[i])
		add_child(new_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
