extends CharacterBody2D

@export var SPEED = 600

var batteries = 0
var idCards = 0

var lastAnimName = ""
var animDir = "down"

func setAnimation():
	var animName = "protag_"
	var animType = "idle_"
	
	if velocity.length() > 1:
		animType = "walk_"
		print("Velocity:" + str(velocity))
		if velocity.x > 5:
			animDir = "left"
			get_node("WalkingProtagSpriteSheet").flip_h = true
		elif velocity.x < -5:
			animDir = "left"
			get_node("WalkingProtagSpriteSheet").flip_h = false
		elif velocity.y > 5:
			animDir = "down"
			get_node("WalkingProtagSpriteSheet").flip_h = false
		elif velocity.y < -5:
			animDir = "up"
			get_node("WalkingProtagSpriteSheet").flip_h = false
	var aName = animName + animType + animDir
	if lastAnimName != aName:
		$AnimationPlayer.play(aName)
		lastAnimName = aName

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "forward", "back")
	velocity = direction * SPEED
	velocity = direction * SPEED
	look_at(get_global_mouse_position())
	move_and_slide()
	
	setAnimation()
