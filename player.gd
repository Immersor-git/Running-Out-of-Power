extends CharacterBody2D

@export var SPEED = 600

var batteries = 0
var idCards = 0

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "forward", "back")
	velocity = direction * SPEED
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()
