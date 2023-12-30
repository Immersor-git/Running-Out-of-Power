extends Sprite2D

#const TextBoxScript = preload("res://text_boxes/descriptor_box.tscn")

#@onready var text_box_script = $descriptor_box


# Called when the node enters the scene tree for the first time.
func _ready():
	#%TextBox.showDescription = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(get_global_mouse_position())):
			%TextBox.showDescription = true
			%TextBox.showBox(get_name())
			#%TextBox.finish_intro()
			#queue_free()
