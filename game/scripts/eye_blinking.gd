class_name EyeBlinking extends Node2D

@export var eye_left_node: Node2D
@export var eye_right_node: Node2D
@export var min_time_between_blinks: float = 1.0
@export var max_time_between_blinks: float = 6.0

var blink_timer: float = 0.0
var blink_state_timer: float = 0.0

func _process(delta):
	blink_timer -= delta
	if blink_timer <= 0.0:
		# we are doing a blink! wohooo!!
		blink_state_timer += delta
		
		# blink end
		if blink_state_timer >= 0.2:
			eye_left_node.visible = true
			eye_right_node.visible = true
			blink_timer = randf_range(min_time_between_blinks, max_time_between_blinks)
			blink_state_timer = 0.0
		elif blink_state_timer >= 0.0:
			eye_left_node.visible = false
			eye_right_node.visible = false
	
