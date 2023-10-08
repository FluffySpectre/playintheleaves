class_name DialogPanel extends Panel

signal dialog_ended

@export var dialog_texts: Array[String] = []

var current_dialog_text_index: int = 0

@onready var text_label: Label = $TextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	display_current_dialog_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not visible:
		return

	if Input.is_action_just_pressed("jump"):
		next_dialog_text()
		display_current_dialog_text()
	
func display_current_dialog_text():
	text_label.text = dialog_texts[current_dialog_text_index]

func next_dialog_text():
	current_dialog_text_index += 1
	if current_dialog_text_index >= dialog_texts.size():
		current_dialog_text_index = dialog_texts.size() - 1
		close_dialog()

func close_dialog():
	visible = false
	dialog_ended.emit()
