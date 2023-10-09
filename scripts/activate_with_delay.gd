class_name ActivateWithDelay extends Node

@export var target_node: Node2D
@export var delay: float = 3.0

var activation_timer: float = 0.0
var done: bool = false

func _process(delta):
	if done:
		return
	
	activation_timer += delta
	if activation_timer >= delay:
		target_node.visible = true
		target_node.process_mode = Node.PROCESS_MODE_INHERIT
		done = true
