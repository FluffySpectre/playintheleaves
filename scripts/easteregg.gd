class_name Easteregg extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_leaf_entered)

func on_leaf_entered(leaf):
	GameManager.instance.easteregg_triggered()
