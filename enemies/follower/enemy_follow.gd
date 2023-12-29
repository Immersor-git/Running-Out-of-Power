extends CharacterBody2D

signal start_following
signal start_homing
signal set_path(path: Line2D)

@export var Path: Line2D
@export var SPEED = 300

func _ready():
	set_path.emit(Path)

func should_follow():
	var player = %DetectBox.get_overlapping_bodies()
	if player.size() > 0:
		start_following.emit()

func _on_handle_follow():
	var player = %DetectBox.get_overlapping_bodies()
	if player.size() > 0:
		look_at(player[0].global_position)
		velocity = Vector2.RIGHT.rotated(global_rotation) * SPEED
	else:
		start_homing.emit()

func _physics_process(delta):
	should_follow()
	move_and_slide()
