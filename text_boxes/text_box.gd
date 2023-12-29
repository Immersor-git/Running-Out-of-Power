extends CanvasLayer

var file_path = "dialogue.json"
var json_as_text = FileAccess.get_file_as_string(file_path)
var json_as_dict = JSON.parse_string(json_as_text)



@onready var textBoxContainer = $TextBoxContainer
@onready var textBoxText = $TextBoxContainer/MarginContainer/HBoxContainer/LabelText



var CHAR_READ_RATE = 0.5
var iterative_text: int = 0
var textToAdd = "this text is added and its a little bit kinda long lmfao"



func _physics_process(delta):
	if Input.is_action_pressed("close_menu"):
		close_textbox()


func _ready():
	close_textbox()
	add_text(textToAdd)
		
func close_textbox():
	textBoxText.text = ""
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
	iterative_text += 1
	print(iterative_text)
	textBoxText.text = textToAdd.substr(0, iterative_text)
	if iterative_text == textToAdd.length():
		$TextBoxContainer/MarginContainer/HBoxContainer/nextChar.stop()
		print("text typing done!")
	 # Replace with function body.
