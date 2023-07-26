extends State
class_name MovePlayerState

@export var entitie : CharacterBody2D
@export var max_walking_velocity : float = 1500
@export var acceleration : float = 50
var speed : float = 0
var direction : int 

func Enter():
	speed = 0
	if Input.is_action_pressed("move_left"):
		direction = -1
		entitie.get_node("Sprite").flip_h = true
	else:
		direction = 1
		entitie.get_node("Sprite").flip_h = false
	entitie.get_node("Sprite").play("walking")
	
func PhysicsProcess(delta):
	if (Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right")) and not(Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		Transitioned.emit(self, "stopping")
		return
	if Input.is_action_pressed("move_left") and direction == 1 or Input.is_action_pressed("move_right") and direction == -1:
		Enter()
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "jumping")
		return
	if not entitie.is_on_floor():
		Transitioned.emit(self, "falling")
		return
	speed += acceleration
	entitie.velocity.x = min(speed, max_walking_velocity)
	entitie.velocity.x *= direction * delta * 10
	entitie.move_and_slide()


