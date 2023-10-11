class_name GameManager extends Node2D

@export var tree_head_scene: PackedScene

static var instance: GameManager
var is_in_intro: bool = true
var easteregg_active: bool = false
var easteregg_shine_timer: float = 0.0
var easteregg_cooldown_timer: float = 0.0
var tree_hits: int = 0
var tree_was_hit: bool = false
var tree_head_visible: bool = false
var tree_head_spawns: int = 0
var tree_head_timer: float = 0.0

@onready var player_movement: PlayerMovement = $Player
@onready var leaf_spawner: Spawner = $LeafSpawner
@onready var intro_dialog: DialogPanel = $Intro/Panel
@onready var easteregg_leaf_shine: Sprite2D = $Tree/Leafs/RigidBody2D/Shine
@onready var tree_head_parent: Node = $TreeHeadParent
@onready var big_tree: BigTree = $Tree

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	
	intro_dialog.connect("dialog_ended", on_intro_dialog_ended)
	
	leaf_spawner.spawn_delay = 5
	easteregg_leaf_shine.visible = false
	big_tree.anger_level = 0

func _process(delta):
	process_easteregg(delta)

func easteregg_triggered():
	# only start the extra spawn, if intro is over
	# and the spawner is not already spawning
	if easteregg_cooldown_timer <= 0.0 and not is_in_intro and not leaf_spawner.is_spawning():
		print ("Easteregg triggered!")
		leaf_spawner.max_spawned_objects = 25
		leaf_spawner.start_spawn()
		easteregg_active = true
		easteregg_shine_timer = 0.0
		easteregg_cooldown_timer = 5.0
		tree_was_hit = false
	else:
		# if no activation, hint that there is something
		easteregg_shine_timer = 2.0

func process_easteregg(delta):
	if tree_head_timer > 0.0:
		tree_head_timer -= delta
		if tree_head_timer <= 0.0:
			despawn_tree_head()
	
	if leaf_spawner.is_spawning() or easteregg_shine_timer > 0.0:
		easteregg_leaf_shine.visible = true
	else:
		easteregg_leaf_shine.visible = false
	
	if easteregg_active:
		if not tree_was_hit:
			hit_tree()
			tree_was_hit = true
		
		if not leaf_spawner.is_spawning():
			easteregg_cooldown_timer -= delta
		
		if easteregg_cooldown_timer <= 0.0:
			easteregg_active = false
	else:
		# hint for the player
		if easteregg_shine_timer > 0.0:
			easteregg_shine_timer -= delta

func hit_tree():
	if tree_hits < 2:
		tree_hits += 1
	else:
		# tree is angry
		if not tree_head_visible:
			instantiate_tree_head()
			tree_head_spawns += 1
			tree_head_timer = tree_head_spawns * 30.0
			tree_head_visible = true
	big_tree.anger_level = tree_hits
	print("Tree hits: " + str(tree_hits))

func instantiate_tree_head():
	var tree_head_instance = tree_head_scene.instantiate()
	tree_head_instance.global_position = Vector2.ZERO
	tree_head_parent.add_child(tree_head_instance)

func despawn_tree_head():
	tree_head_parent.get_child(0).queue_free()
	tree_hits = 0
	tree_head_visible = false
	big_tree.anger_level = 0

func enable_player_control():
	player_movement.toggle_player_control(true)

func disable_player_control():
	player_movement.toggle_player_control(false)

func on_intro_dialog_ended():
	is_in_intro = false
	enable_player_control()
	leaf_spawner.spawn_delay = 0.25 # let it rain
