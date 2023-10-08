class_name PlayerMovement extends CharacterBody2D

const SPEED = 75.0 # 300.0
const SPEED_MULTI = 3.0
const JUMP_VELOCITY = -400.0

# get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_direction: Vector2 = Vector2.RIGHT
var player_controllable: bool = false
var block_first_update: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var player_footsteps: PlayerFootsteps = $PlayerFootsteps

func toggle_player_control(enable_control: bool):
	player_controllable = enable_control
	block_first_update = true
	print("HIER")

func _physics_process(delta):
	if block_first_update:
		block_first_update = false
		return
	
	# add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	if player_controllable:
		# handle jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# handle running
		var run_multi = 1.0
		if Input.is_action_pressed("run"):
			run_multi = SPEED_MULTI
			player_footsteps.player_is_running(true)
		else:
			player_footsteps.player_is_running(false)

		# get the input direction and handle the movement/deceleration
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED * run_multi
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED * run_multi)

	move_and_slide()

	update_sprite_direction(velocity)

func update_sprite_direction(vel: Vector2):
	if vel.x < 0 and not last_direction.x < 0:
		last_direction = vel
		sprite.flip_h = true
		
	if vel.x > 0 and not last_direction.x > 0:
		last_direction = vel
		sprite.flip_h = false
