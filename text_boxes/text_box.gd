extends CanvasLayer

var file_path = "res://text_boxes/dialogue.json"
var itemData = {}
@export var showDescription : bool = false



@onready var textBoxContainer = $TextBoxContainer
@onready var textBoxText = $TextBoxContainer/MarginContainer/HBoxContainer/LabelText

var iterative_text: int = 0
var textToAdd = "Q text is added and its a little bit kinda long lmfao"

func _physics_process(delta):
	if Input.is_action_pressed("close_menu"):
		showDescription = false
		iterative_text = 0
		close_textbox()
		get_tree().change_scene_to_file("res://tileset/Main_Scene.tscn")
	#if Input.is_action_pressed("")


func _ready():
	close_textbox()
	#if showDescription:
		#textToAdd = _load_json_file(file_path, "Motherboard")
		#print(textToAdd[0])
		#add_text(textToAdd[0])



func showBox(interactObject : String):
	close_textbox()
	if showDescription:
		textToAdd = _load_json_file(file_path, interactObject)
		print(textToAdd[0])
		add_text(textToAdd[0])

	#SignalBus.connect("display_dialogue", self,"on_display_dialogue")


func _load_json_file(filePath : String, interactionSource : String):
	if FileAccess.file_exists(filePath):
		var datafile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(datafile.get_as_text())
		
		if parsedResult is Dictionary:
			print(parsedResult[interactionSource])
			return parsedResult[interactionSource]
		else:
			print("error reading file")
	else:
		print("error, no file exists")
		

func _load_scene_text():
	pass
		
func close_textbox():
	#textBoxText.text = ""
	textBoxContainer.hide()

func show_textbox():
	textBoxContainer.show()

func add_text(next_text):
	textBoxText.text = next_text
	show_textbox()


#func set_text(new_text: String):
	#textBoxText = new_text
	#iterative_text = 0

func _on_character_timeout():
	#var mainString = textBoxText.get_text()
	print(iterative_text)
	if showDescription:
		iterative_text += 1
		print(iterative_text)
		textBoxText.text = textToAdd[0].substr(0, iterative_text)
		#if iterative_text == textToAdd[0].length():
			#$TextBoxContainer/MarginContainer/HBoxContainer/nextChar.stop()
			#iterative_text = 0
		print("text typing done!")

