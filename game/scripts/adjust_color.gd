class_name AdjustColor extends Sprite2D

@export var adjustment_min: float = -80
@export var adjustment_max: float = 80

func _ready():
	var adjustment = randf_range(adjustment_min, adjustment_max)
	modulate.r += adjustment / 255.0
	modulate.g += adjustment / 255.0
	modulate.b += adjustment / 255.0
