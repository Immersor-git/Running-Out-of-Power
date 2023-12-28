extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var state = "Curious"

var targetPosition = Vector2(0,0)
var actualPosition = Vector2(0,0)

func state_Curious():
	get_node("Polygon2D").stateCurious()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 300:
		velocity = Vector2(200,0).rotated(global_rotation)
	elif distance < 150:
		velocity = Vector2(-200,0).rotated(global_rotation)
	else:
		velocity = Vector2(0,60).rotated(global_rotation)
		
func state_Threatened():
	get_node("Polygon2D").stateThreatened()
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 300:
		velocity = Vector2(100,0).rotated(global_rotation)
	elif distance < 150:
		velocity = Vector2(-100,0).rotated(global_rotation)	

func target_position():
	return get_global_mouse_position()
	
func movement():
	var diff = targetPosition - global_position
	var distance = diff.length()
	if distance > 300:
		velocity = Vector2(200,0).rotated(global_rotation)
	else:
		velocity = Vector2(-200,0).rotated(global_rotation)
	

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	actualPosition = target_position();
	targetPosition = targetPosition.lerp(actualPosition,0.04)
	look_at(targetPosition)
	movement()
	#state_Curious()

	move_and_slide()
