class_name ApplyForceTowardsTarget extends Node

@export var target_node: Node2D
@export var target_node_name: String
@export var force_strength: float = 4000.0

@onready var parent_body: RigidBody2D = get_parent()

func _ready():
  # if a node path is set, use this instead
  if target_node_name:
    target_node = get_tree().root.get_node(target_node_name)

func _physics_process(_delta):
  var target_dir = target_node.global_position - parent_body.global_position
  target_dir = target_dir.normalized()
  target_dir *= force_strength
  parent_body.apply_central_force(target_dir)
