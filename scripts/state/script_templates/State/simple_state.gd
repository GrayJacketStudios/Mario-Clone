extends State
class_name templatestate

@export var entitie : CharacterBody2D
@onready var animation : AnimatedSprite2D = entitie.get_node("Sprite")

func Enter():
	pass

func Process(_delta):
	pass

func PhysicsProcess(_delta):
	pass

func Exit():
	pass	
