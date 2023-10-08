class_name GameManager extends Node2D

static var instance: GameManager
var is_in_intro: bool = true
var easteregg_active: bool = false
var easteregg_shine_timer: float = 0.0

@onready var player_movement: PlayerMovement = $Player
@onready var leaf_spawner: Spawner = $LeafSpawner
@onready var intro_dialog: DialogPanel = $Intro/Panel
@onready var easteregg_leaf_shine: Sprite2D = $Tree/Leafs/RigidBody2D/Shine

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	
	intro_dialog.connect("dialog_ended", on_intro_dialog_ended)
	
	leaf_spawner.spawn_delay = 5
	easteregg_leaf_shine.visible = false

func _process(delta):
	process_easteregg(delta)

func easteregg_triggered():
	# only start the extra spawn, if intro is over
	# and the spawner is not already spawning
	if not is_in_intro and not leaf_spawner.is_spawning():
		print ("Easteregg triggered!")
		leaf_spawner.max_spawned_objects = 25
		leaf_spawner.start_spawn()
		easteregg_active = true
		easteregg_shine_timer = 0.0
	else:
		# if no activation, hint that there is something
		easteregg_shine_timer = 2.0

func process_easteregg(delta):
	if easteregg_active:
		if leaf_spawner.is_spawning():
			easteregg_leaf_shine.visible = true
		else:
			easteregg_leaf_shine.visible = false
			easteregg_active = false
	else:
		# hint for the player
		if easteregg_shine_timer > 0.0:
			easteregg_shine_timer -= delta
			if (easteregg_shine_timer > 0.0):
				easteregg_leaf_shine.visible = true
			else:
				easteregg_leaf_shine.visible = false

func enable_player_control():
	player_movement.toggle_player_control(true)

func disable_player_control():
	player_movement.toggle_player_control(false)

func on_intro_dialog_ended():
	is_in_intro = false
	enable_player_control()
	leaf_spawner.spawn_delay = 0.25 # let it rain
