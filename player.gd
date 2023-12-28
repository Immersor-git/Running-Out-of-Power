extends CharacterBody2D


func _physics_process(_delta):
	const SPEED = 600
	var direction = Vector2.ZERO
	if Input.is_action_pressed("LEFT"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("RIGHT"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("DOWN"):
		direction += Vector2.DOWN
	if Input.is_action_pressed("UP"):
		direction += Vector2.UP
	direction = direction.normalized()
	velocity = direction * SPEED
	move_and_slide()
