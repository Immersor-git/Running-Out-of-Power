extends AnimationTree

@onready var anim_tree : AnimationTree = $AnimationTree

func setAggro(ag):
	anim_tree["parameters/conditions/is_aggro"] = ag
	anim_tree["parameters/conditions/is_neutral"] = not ag

func setAttack(at):
	anim_tree["parameters/conditions/is_attacking"] = at
	if at == true:
		anim_tree["parameters/conditions/is_neutral"] = false
		anim_tree["parameters/conditions/is_aggro"] = false

func setDirection(dir):
	if dir == 0:
		print("down")
		anim_tree["parameters/conditions/face_down"] = true
		anim_tree["parameters/conditions/face_up"] = false
		anim_tree["parameters/conditions/face_right"] = false
	elif dir == 1:
		print("right")
		anim_tree["parameters/conditions/face_down"] = false
		anim_tree["parameters/conditions/face_up"] = false
		anim_tree["parameters/conditions/face_right"] = true
	elif dir == 2:
		print("up")
		anim_tree["parameters/conditions/face_down"] = false
		anim_tree["parameters/conditions/face_up"] = true
		anim_tree["parameters/conditions/face_right"] = false
