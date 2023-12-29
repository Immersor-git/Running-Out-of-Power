extends CharacterBody2D

const SPEED = 600.0

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "forward", "back")
	velocity = direction * SPEED
	move_and_slide()
	
	var rot = get_global_mouse_position()
	look_at(rot)
