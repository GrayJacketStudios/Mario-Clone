extends State
class_name StoppingPlayerState

@export var entitie : CharacterBody2D
@export var desacceleration : float = 20


func Enter():
	entitie.get_node("Sprite").play("walking")
	
func PhysicsProcess(delta):
	if (absf(round(entitie.velocity.x)) <= 0):
		Transitioned.emit(self, "idle")
		return
	if not entitie.is_on_floor() and entitie.velocity.y >= 0:
		Transitioned.emit(self, "falling")
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, "moving")
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "jumping")
		return
	if abs(entitie.velocity.x) >= 0:
		entitie.velocity.x = lerp(entitie.velocity.x, 0.0, delta * desacceleration)
		entitie.move_and_slide()
