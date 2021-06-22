extends Node2D

var exit

func _ready():
	exit = get_tree().get_nodes_in_group("exit")[0]
	state = get_child(0)
	call_deferred("_enter_state")


func footstep():
	audioholder.play_audio("footstep0%d" % [randi() % 10], -20)


func change_to(new_state):
	history.append(state.name)
	state = get_node(new_state)
	_enter_state()


func back():
	if history.size() > 0:
		state = get_node(history.pop_back())
		_enter_state()


func _enter_state():
	if globals.debug:
		print("Entering state: ", state.name)
		printt(history)
	# Give the new state a reference to it's state machine i.e. this one
	state.fsm = self
	state.enter()


func _process(delta):
	if state.has_method("process"):
		state.process(delta)

