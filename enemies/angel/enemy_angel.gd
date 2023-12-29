extends CharacterBody2D

signal start_following
signal start_homing
signal set_path(path: Line2D)

@export var Path: Line2D
@export var SPEED = 3000

func _ready():
	set_path.emit(Path)

func should_follow():
	var player = %DetectBox.get_overlapping_bodies()
	if player.size() > 0:
		start_following.emit()

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

func _physics_process(delta):
	should_follow()
	move_and_slide()
