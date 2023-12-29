extends Node2D

@export var parent: CharacterBody2D
var Path: Line2D
var closest_point
var next_node
var state = STATE.HOMING

enum STATE {PATROLLING, HOMING, FOLLOWING}

signal handle_follow

func _ready():
	parent = get_parent()

func set_path(path):
	Path = path
	#Path.visible = false
	Path.top_level = true
	update_closest_point()
	print(next_node)

func _on_start_homing():
	update_closest_point()
	state = STATE.HOMING

func _on_start_following():
	state = STATE.FOLLOWING

func update_closest_point():
	for i in Path.points.size():
		var global_point = Path.to_global(Path.get_point_position(i))
		if not closest_point:
			closest_point = global_point
		var distance_to_point = global_point.distance_to(global_position)
		var closest_known_point = closest_point.distance_to(global_position)
		if distance_to_point <= closest_known_point:
			closest_point = global_point
			next_node = (i + 1) % Path.points.size()

func _physics_process(delta):
	parent.velocity = Vector2.ZERO
	if Path:
		if state == STATE.HOMING:
			parent.look_at(closest_point)
			parent.velocity = Vector2.RIGHT.rotated(parent.global_rotation) * parent.SPEED
			if closest_point.distance_to(global_position) < (parent.SPEED / 60):
				state = STATE.PATROLLING
		elif state == STATE.PATROLLING:
			var next_point = Path.to_global(Path.get_point_position(next_node))
			var distance_to_next_point = next_point.distance_to(global_position)
			if distance_to_next_point < (parent.SPEED / 60):
				for i in Path.points.size():
					if closest_point == Path.to_global(Path.get_point_position(i)):
						next_node = (i + 1) % Path.points.size()
			else:
				closest_point = Path.to_global(Path.get_point_position(next_node))
				parent.look_at(closest_point)
				parent.velocity = Vector2.RIGHT.rotated(parent.global_rotation) * parent.SPEED
		elif state == STATE.FOLLOWING:
			handle_follow.emit()
