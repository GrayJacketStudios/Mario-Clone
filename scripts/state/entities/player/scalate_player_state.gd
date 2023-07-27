extends State
class_name ScalingCornerPlayerState

@export var entitie : CharacterBody2D
@onready var animation : AnimatedSprite2D = entitie.get_node("Sprite")

var impulse_velocity = -140
var direction : int = 1

func Enter():
	entitie.velocity.y = impulse_velocity
	direction = 1 if not animation.flip_h else -1


func Process(delta):
	if entitie.is_on_floor():
		Transitioned.emit(self, "idle")
	entitie.velocity.y += 9.8 * delta * 30
	entitie.velocity.x = direction * 100
	entitie.move_and_slide()
