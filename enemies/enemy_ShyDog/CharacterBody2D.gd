extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.

@export var Player: CharacterBody2D;

enum STATE {Curious,Threatened,Attacking}

var state = STATE.Curious

var targetPosition = Vector2(0,0)
var actualPosition = Vector2(0,0)

var started = false

var action = false
var lookPlayer = true

var currentLook = 0
var targetLook = 0

var gvelocity = Vector2(0,0)

var lastdir = 0
var curdir = 0

var circleDirection = 0

var timer = Timer.new()

var lastAnim = ""
func updateAnimation():
	var idleName = "shydogs_idle_"
	var stateName = "neutral_"
	var dogDir = "up"
	
	var animspeed = 1
	if state == STATE.Curious:
		stateName = "neutral_"
	else:
		stateName = "aggro_"
		
	if curdir == 0:
		dogDir = "up"
	elif curdir == 1:
		dogDir = "right"
	else:
		dogDir = "down"
		
	if state == STATE.Attacking:
		lastAnim = ""
		idleName = "shydogs_leap_"
		stateName = "aggro_"
		if lookPlayer:
			animspeed = 0.4
		else:
			animspeed = 1
		
	var animName = idleName + stateName + dogDir
	if animName != lastAnim:
		$AnimationPlayer.pause()
		$AnimationPlayer.set_speed_scale(animspeed)
		$AnimationPlayer.play(animName)
		$AnimationPlayer.advance(0)
		lastAnim = animName
		#print(animName)
		
		
		

func handleDirection():
	var rot = global_rotation + PI + PI/4
	#print("PlayerDir: "+str(floor(rot / TAU * 360)))
	var flip = false
	if rot < TAU/4:
		curdir = 1
		flip = true
	elif rot < TAU/4 * 2:
		curdir = 0
	elif rot < TAU/4 * 3:
		curdir = 1
	elif rot < TAU/4 * 4:
		curdir = 2
	else:
		curdir = 1
		flip = true
	if lastdir != curdir:
		lastdir = curdir
		get_node("DogSprite").flip_h = flip
	#print("Direction: "+str(curdir))
func stateCurious():
	get_node("%Doggygon").stateCurious()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 900:
		velocity = Vector2(200,150*circleDirection).rotated(global_rotation)
	elif distance < 500:
		velocity = Vector2(-600,0*circleDirection).rotated(global_rotation)
	elif distance < 800:
		velocity = Vector2(-150,100*circleDirection).rotated(global_rotation)
	else:
		velocity = Vector2(0,100*circleDirection).rotated(global_rotation)
		
func stateThreatened():
	get_node("%Doggygon").stateThreatened()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 650:
		velocity = Vector2(150,0).rotated(global_rotation)
	elif distance < 350:
		velocity = Vector2(-700,0).rotated(global_rotation)	
	elif distance < 550:
		velocity = Vector2(-400,0).rotated(global_rotation)	
	else:
		velocity = Vector2(0,0)
				
func stateAttacking():
	action = true
	lookPlayer = true
	gvelocity = Vector2(-20,0).rotated(global_rotation)
	get_node("%Doggygon").stateWindup()
	await get_tree().create_timer(1).timeout
	lookPlayer = false
	actualPosition = global_position + (actualPosition - global_position)*2
	get_node("%Doggygon").stateAttack()
	gvelocity = Vector2(1400,0).rotated(global_rotation)
	#print("V1")
	#print(velocity)
	await get_tree().create_timer(0.4).timeout
	#print("V2")
	#print(velocity)
	gvelocity = Vector2(600,0).rotated(global_rotation)
	await get_tree().create_timer(0.6).timeout
	lookPlayer = true
	action = false
	state = STATE.Threatened

func target_position():
	return Player.global_position - Vector2(0,15)

func _physics_process(delta):
	if started == false: return
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	get_node("DogSprite").global_rotation = 0
	if lookPlayer:
		actualPosition = target_position();
		targetPosition = targetPosition.lerp(actualPosition,0.04)
		look_at(targetPosition)
	else:
		targetPosition = actualPosition
		
	look_at(targetPosition)
	
	
	if state == STATE.Curious:
		stateCurious()
		if (global_position - targetPosition).length() > 1800:
			return
	elif state == STATE.Threatened:
		stateThreatened()
	else:
		velocity = gvelocity
	#state_Curious()
	#print("Vel:"+str(velocity))
	handleDirection()
	updateAnimation()
	move_and_slide()
	
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var colName = collision.get_collider().name
		if name == "PlayerHitbox":
			print("I collided with ", collision.get_collider().name)
	
func behavior():
	if action: 
		return
	
	if state == STATE.Curious:
		state = STATE.Threatened
	else:
		var doesLunge = randf_range(0,1)
		#print("AttackChance")
		#print(doesLunge)
		if doesLunge < 0.9:
			state = STATE.Attacking
			await stateAttacking()
		circleDirection = randi_range(0,1) * 2 -1
		state = STATE.Curious
			
	#print("Setting state")
	#print("State")
	
	get_node("Timer").wait_time = randi_range(3,7)
	
func _ready():
	started = true
	#print("Starting")
	circleDirection = randi_range(-1,1)
	get_node("Timer").wait_time = randi_range(3,7)
	get_node("Timer").start()


func _on_timer_timeout():
	behavior()
	get_node("Timer").wait_time = randf_range(3,7)
