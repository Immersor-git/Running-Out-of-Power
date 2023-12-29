extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.

enum STATE {Curious,Threatened,Attacking}

var state = STATE.Curious

var targetPosition = Vector2(0,0)
var actualPosition = Vector2(0,0)

var action = false

var circleDirection = 0

var timer = Timer.new()

func stateCurious():
	get_node("%Doggygon").stateCurious()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 360:
		velocity = Vector2(200,100*circleDirection).rotated(global_rotation)
	elif distance < 150:
		velocity = Vector2(-400,200*circleDirection).rotated(global_rotation)
	elif distance < 300:
		velocity = Vector2(-150,100*circleDirection).rotated(global_rotation)
	else:
		velocity = Vector2(0,100*circleDirection).rotated(global_rotation)
		
func stateThreatened():
	get_node("%Doggygon").stateThreatened()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 210:
		velocity = Vector2(100,0).rotated(global_rotation)
	elif distance < 200:
		velocity = Vector2(-300,0).rotated(global_rotation)	
	else:
		velocity = Vector2(0,0)
		
func stateAttacking():
	action = true
	velocity = Vector2(0,0)
	get_node("%Doggygon").stateWindup()
	actualPosition = global_position + (actualPosition - global_position)*2
	await get_tree().create_timer(1.0).timeout
	get_node("%Doggygon").stateAttack()
	velocity = Vector2(500,0).rotated(global_rotation)
	await get_tree().create_timer(0.7).timeout
	velocity = Vector2(500,0).rotated(global_rotation)
	state = STATE.Threatened
	await get_tree().create_timer(0.3).timeout
	action = false

func target_position():
	return get_parent().get_node("player").global_position

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if action == false:
		actualPosition = target_position();
	
	targetPosition = targetPosition.lerp(actualPosition,0.04)
	look_at(targetPosition)
	
	
	if state == STATE.Curious:
		stateCurious()
	elif state == STATE.Threatened:
		stateThreatened()
	#state_Curious()

	move_and_slide()
	
func behavior():
	if action: 
		return
	
	if state == STATE.Curious:
		state = STATE.Threatened
	else:
		var doesLunge = randf()
		print("AttackChance")
		print(doesLunge)
		if doesLunge < 0.5:
			state = STATE.Attacking
			stateAttacking()
		else:
			circleDirection = randi_range(-1,1)
			state = STATE.Curious
	print("Setting state")
	print("State")
	
func _ready():
	print("Starting")
	circleDirection = randi_range(-1,1)
	get_node("Timer").wait_time = randi_range(3,7)


func _on_timer_timeout():
	behavior()
	get_node("Timer").wait_time = randi_range(3,7)
