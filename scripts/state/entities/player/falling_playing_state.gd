extends State
class_name FallingPlayerState

@export var GRAVITY: float = 9.8

@export var entitie : CharacterBody2D
@onready var animation : AnimatedSprite2D = entitie.get_node("Sprite")
var time : float

var hangRaycast1 : RayCast2D
@export var hangRaycast1Offset : Vector2 = Vector2(0, -15)
var hangRaycast2 : RayCast2D
@export var hangRaycast2Offset : Vector2= Vector2.ZERO

func Enter():
	animation.play("falling")
	time = Time.get_unix_time_from_system()
	var direction = 1 if not animation.flip_h else -1
	hangRaycast1 = RayCast2D.new()
	hangRaycast2 = RayCast2D.new()
	hangRaycast1.position = hangRaycast1Offset
	hangRaycast2.position = hangRaycast2Offset
	hangRaycast1.name = "hangRaycasts1"
	hangRaycast1.target_position = Vector2(20 * direction, 0)
	entitie.add_child(hangRaycast1)
	hangRaycast2.name = "hangRaycasts2"
	hangRaycast2.target_position = Vector2(20 * direction, 0)
	entitie.add_child(hangRaycast2)

func Exit():
	hangRaycast1.queue_free()
	hangRaycast2.queue_free()

func check_can_jump() -> bool:
	return (Input.is_action_just_pressed("jump") and get_parent().previous_state.name == "moving" and Time.get_unix_time_from_system() - time <= 0.2)

func should_hang() -> bool:
	return not hangRaycast1.is_colliding() and hangRaycast2.is_colliding()

func PhysicsProcess(delta):
	if should_hang():
		Transitioned.emit(self, "hanging")
		return
	if check_can_jump():
		Transitioned.emit(self, "jumping")
		return
	if Input.is_action_pressed("move_left"):
		entitie.velocity.x = lerp(entitie.velocity.x, -100.0, delta)
	elif Input.is_action_pressed("move_right"):
		entitie.velocity.x = lerp(entitie.velocity.x, 100.0, delta)
	if not entitie.is_on_floor():
		entitie.velocity.y += GRAVITY * delta * 30
		entitie.move_and_slide()
	else:
		Transitioned.emit(self, "stopping")
