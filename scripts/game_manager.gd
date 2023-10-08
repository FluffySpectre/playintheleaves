class_name GameManager extends Node2D

static var instance: GameManager

@onready var player_movement: PlayerMovement = $Player
@onready var leaf_spawner: Spawner = $LeafSpawner
@onready var intro_dialog: DialogPanel = $Intro/Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	
	intro_dialog.connect("dialog_ended", on_intro_dialog_ended)
	
	leaf_spawner.spawn_delay = 5

func enable_player_control():
	player_movement.toggle_player_control(true)

func disable_player_control():
	player_movement.toggle_player_control(false)

func on_intro_dialog_ended():
	enable_player_control()
	leaf_spawner.spawn_delay = 0.25 # let it rain
