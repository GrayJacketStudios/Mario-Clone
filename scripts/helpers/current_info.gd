extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("p_changed_state", change_player_state)


func change_player_state(state):
	$Panel/VBoxContainer/HBoxState/player_state.text = state

func change_player_animation(animation):
	$Panel/VBoxContainer/HBoxAnimation/player_animation.text = animation
