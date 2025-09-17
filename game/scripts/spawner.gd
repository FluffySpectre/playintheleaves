class_name Spawner extends Area2D

@export var spawn_list: Array[PackedScene]
@export var autostart: bool = false
@export var spawn_delay: float = 0.25
@export var max_spawned_objects: int = 50
@export var spawn_container: Node
@export var apply_random_torque: bool = true
@export var one_shot_spawn: bool = false

var spawn_timer = spawn_delay
var do_spawn = false
var rng = RandomNumberGenerator.new()
var spawned_objects: int = 0

@onready var spawn_area = $CollisionShape2D.shape.get_rect()

func is_spawning() -> bool:
  return do_spawn and spawned_objects < max_spawned_objects

func _ready():
  if autostart:
    start_spawn()

func _process(delta):
  # debug
  if Input.is_action_just_pressed("debug1"):
    start_spawn()
  
  if not do_spawn or spawned_objects >= max_spawned_objects or one_shot_spawn:
    return
  
  spawn_timer -= delta
  if spawn_timer <= 0:
    spawn()
    spawn_timer = spawn_delay

func start_spawn():
  do_spawn = true
  spawn_timer = spawn_delay
  spawned_objects = 0
  
  if one_shot_spawn:
    do_one_shot_spawn()
  
  print("Start spawning")
  
func spawn():
  # select a random scene from the spawn list
  var to_spawn = spawn_list[randi() % spawn_list.size()]
  
  var instance = to_spawn.instantiate()
  instance.global_position = get_random_point_in_spawnarea()
  instance.global_rotation = global_rotation
  
  # apply some torque
  if apply_random_torque and instance is RigidBody2D:
    instance.apply_torque(randf_range(20.0, 100.0))
  
  spawn_container.add_child(instance)
  
  spawned_objects += 1

func do_one_shot_spawn():
  for i in max_spawned_objects:
    spawn()

func get_random_point_in_spawnarea():
  var x = global_position.x + rng.randf_range(0, spawn_area.size.x)
  var y = global_position.y + rng.randf_range(0, spawn_area.size.y)
  return Vector2(x, y)
