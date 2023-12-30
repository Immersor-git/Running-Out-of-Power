extends CharacterBody2D

signal start_following
signal start_homing
signal set_path(path: Line2D)

@export var Path: Line2D
@export var SPEED = 800

func _ready():
	set_path.emit(Path)

func should_follow():
	var player = %DetectBox.get_overlapping_bodies()
	if player.size() > 0:
		start_following.emit()
		if %approaching.playing == false:
			%approaching.playing = true
	elif %approaching.playing == true:
		%approaching.playing = false
		%noticed.playing = true

func check_angle_distance(angle1, angle2):
	var min_angle = fmod(min(angle1, angle2), TAU)
	var max_angle = fmod(max(angle1, angle2), TAU)
	return min(max_angle - min_angle, min_angle + TAU - max_angle)

func _on_handle_follow():
	var player = %DetectBox.get_overlapping_bodies()
	velocity = Vector2.ZERO
	if player.size() > 0:
		var player_pos = player[0].global_position
		var angle_rot = player_pos.angle_to_point(global_position)
		if  check_angle_distance(player[0].global_rotation, angle_rot) > 0.4:
			look_at(player[0].global_position)
			velocity = Vector2.RIGHT.rotated(global_rotation) * SPEED
			#print('VELOCITY IS', abs(velocity[0]))
			#down is 0, 800
			#up is 0, -800
			#left is -800, 0
			#right is 800, 0

func _physics_process(delta):
	should_follow()
	move_and_slide()
	if velocity != Vector2.ZERO:
		if abs(velocity[0]) > abs(velocity[1]):
			if velocity[0] > 0:
				print('MOVING RIGHT')
				$AnimationPlayer.play('moveSide')
				$AngelSpriteSheet.flip_h = true
			else:
				print('MOVING LEFT')
				$AngelSpriteSheet.flip_h = false
				$AnimationPlayer.play('moveSide')
		else:
			if velocity[1] > 0:
				print('MOVING DOWN')
				$AnimationPlayer.play('moveDown')
			else:
				print('MOVING UP')
				$AnimationPlayer.play('moveUp')
