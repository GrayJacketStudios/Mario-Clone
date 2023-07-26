extends State
class_name IdlePlayerState

@export var entitie : CharacterBody2D

func Enter():
	entitie.get_node("Sprite").play("idle_1")
	entitie.velocity = Vector2(0, 0)

func PhysicsProcess(delta):
	if not entitie.is_on_floor() and entitie.velocity.y >= 0:
		Transitioned.emit(self, "falling")
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		Transitioned.emit(self, "moving")
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "jumping")
		return
	
