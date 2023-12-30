extends Node2D


func _physics_process(delta):
	if %ambient_main.playing == false:
		%ambient_main.playing = true
