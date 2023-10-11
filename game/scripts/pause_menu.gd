class_name PauseMenu extends Node

@onready var pause_menu: Panel = $MenuPanel

func _ready():	
	pause_menu.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		#get_tree().paused = not get_tree().paused
		pause_menu.visible = not pause_menu.visible

func continue_game():
	#get_tree().paused = false
	pause_menu.visible = false

func quit_game():
	get_tree().quit()
