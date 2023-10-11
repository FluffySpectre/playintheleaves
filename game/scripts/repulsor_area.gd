class_name RepulsorArea extends Area2D

@onready var parent_body: CharacterBody2D = get_parent()

var leaf_touch_count: int = 0

func is_touching_leaf() -> bool:
	return leaf_touch_count > 0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", on_body_entered)
	connect("body_exited", on_body_exited)

func on_body_entered(body):
	if body is RigidBody2D:
		# Push the leaf when colliding
		var dirX = 0.0
		var dirY = 0.0
		if parent_body.velocity.x > 0.0:
			dirX = 1.0
		elif parent_body.velocity.x < 0.0:
			dirX = -1.0
			
		if parent_body.velocity.y > 0.0:
			dirY = 1.0
		elif parent_body.velocity.y < 0.0:
			dirY = -1.0
				
		var push_vector = Vector2(dirX * 1.0, dirY * 0.25)
		body.apply_central_impulse(push_vector)
		
		leaf_touch_count += 1

func on_body_exited(body):
	if body is RigidBody2D:
		leaf_touch_count -= 1
