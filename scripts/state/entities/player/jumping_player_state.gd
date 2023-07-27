extends State
class_name JumpingPlayerState

@export var entitie : CharacterBody2D
@export var jump_speed : float = -250
@onready var animation : AnimatedSprite2D = entitie.get_node("Sprite")

var hangRaycast1 : RayCast2D
@export var hangRaycast1Offset : Vector2 = Vector2(0, -15)
var hangRaycast2 : RayCast2D
@export var hangRaycast2Offset : Vector2= Vector2.ZERO

func Enter():
	animation.play("jump")
	entitie.velocity.y = jump_speed
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
	
func should_hang() -> bool:
	var rcFloorCheck : RayCast2D = RayCast2D.new()
	rcFloorCheck.target_position = Vector2(0, 45)
	entitie.add_child(rcFloorCheck)
	rcFloorCheck.force_raycast_update()
	var isFloorNear =  rcFloorCheck.is_colliding()
	rcFloorCheck.queue_free()
	return  not isFloorNear and get_parent().previous_state.name != "hanging" and not hangRaycast1.is_colliding() and hangRaycast2.is_colliding()

func PhysicsProcess(delta):
	if should_hang():
		Transitioned.emit(self, "hanging")
		return
	
	entitie.velocity.y += 9.8 * delta * 30
	
	if Input.is_action_pressed("move_left"):
		entitie.velocity.x = lerp(entitie.velocity.x, -100.0, delta)
	elif Input.is_action_pressed("move_right"):
		entitie.velocity.x = lerp(entitie.velocity.x, 100.0, delta)
	entitie.move_and_slide()
	
	if entitie.velocity.y >= 10:
		Transitioned.emit(self, "falling")
