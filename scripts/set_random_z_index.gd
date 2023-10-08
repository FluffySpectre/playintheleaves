class_name SetRandomZIndex extends Node2D

@export var possible_indizes: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if randf() < 0.25:
		z_index = possible_indizes[1]
	else:
		z_index = possible_indizes[0]
	
	#z_index = possible_indizes[randi() % possible_indizes.size()]

