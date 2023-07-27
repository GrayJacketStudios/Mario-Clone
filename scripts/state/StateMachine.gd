extends Node
class_name StateMachine

@export var initial_state : State

var states : Dictionary = {}
var current_state : State
@onready var previous_state : State = initial_state

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Process(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.PhysicsProcess(delta)

func on_child_transition(state, new_state):
	if state != current_state:
		return
	if new_state == "previous":
		new_state = previous_state.name
	var tmp_state = states.get(new_state.to_lower())
	if !tmp_state:
		return
	Events.emit_signal("p_changed_state", tmp_state.name)
	if current_state:
		current_state.Exit()
	previous_state = current_state
	tmp_state.Enter()
	current_state = tmp_state
