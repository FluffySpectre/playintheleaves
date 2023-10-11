class_name RandomMovement extends Node

@export var target_node: Node2D
@export var speed: float = 3.0
@export var max_movement_x: float = 100.0
@export var max_movement_y: float = 50.0
@export var min_wait_time_at_target: float = 2.0
@export var max_wait_time_at_target: float = 8.0

var current_target_pos: Vector2 = Vector2.ZERO
var wait_timer: float = 0.0
var wait_a_bit: bool = false

func _physics_process(delta):
	# are we near the current target?
	# pick a new target
	if target_node.global_position.distance_to(current_target_pos) < 1:
		if not wait_a_bit and wait_timer == 0.0:
			wait_timer = randf_range(min_wait_time_at_target, max_wait_time_at_target)
			wait_a_bit = true
		if wait_a_bit and wait_timer > 0.0:
			wait_timer -= delta
		if wait_a_bit and wait_timer <= 0.0:
			current_target_pos = get_random_target()
			wait_a_bit = false
			wait_timer = 0.0
		return

	target_node.global_position = target_node.global_position.move_toward(current_target_pos, speed * delta)

func get_random_target():
	var random_x = randf_range(-max_movement_x, max_movement_x)
	var random_y = randf_range(-max_movement_y, max_movement_y)
	return Vector2(random_x, random_y)
