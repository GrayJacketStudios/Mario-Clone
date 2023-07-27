extends State
class_name HangCornerPlayerState

@export var entitie : CharacterBody2D
@onready var animation : AnimatedSprite2D = entitie.get_node("Sprite")
@export var hanging_time : float = 3
var start_time : float


func Enter():
	start_time = Time.get_unix_time_from_system()

func Process(_delta):
	pass

func PhysicsProcess(_delta):
	if Time.get_unix_time_from_system() - start_time >= hanging_time:
		Transitioned.emit(self, "previous")
		return
	if Input.is_action_just_pressed("jump"):
		Transitioned.emit(self, "scalate")
	if Input.is_action_pressed("look_down"):
		Transitioned.emit(self, "falling")
func Exit():
	pass	
