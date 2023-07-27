extends State
class_name MovePlayerState

@export var entitie : CharacterBody2D
@export var max_walking_velocity : float = 150
@export var acceleration : float = 5
var direction : int 

func Enter():
	if Input.is_action_pressed("move_left"):
		direction = -1
	elif Input.is_action_pressed("move_right"):
		direction = 1
	entitie.get_node("Sprite").play("walking")

func detectSpriteDirection():
	if entitie.velocity.x > 0 and entitie.get_node("Sprite").flip_h:
		entitie.get_node("Sprite").flip_h = false
	elif entitie.velocity.x < 0 and not entitie.get_node("Sprite").flip_h:
		entitie.get_node("Sprite").flip_h = true
	
func PhysicsProcess(delta):
	if  not(Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
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
	detectSpriteDirection()
	
	entitie.velocity.x = lerp(entitie.velocity.x, direction * max_walking_velocity, acceleration * delta)
	entitie.move_and_slide()


