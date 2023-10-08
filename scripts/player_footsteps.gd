class_name PlayerFootsteps extends Node

@export var footstep_sounds_on_leafs: Array[AudioStream] = []
@export var footstep_sounds_on_concrete: Array[AudioStream] = []
@export var footstep_delay = 0.6
@export var footstep_delay_running = 0.4
@export var repulsor_area: RepulsorArea

var footstep_timer: float = 0.0
var is_currently_moving: bool = false
var is_currently_jumping: bool = false
var is_currently_landed: bool = false
var last_footstep_sound_index = -1

@onready var parent_body: CharacterBody2D = get_parent()
@onready var step_delay: float = footstep_delay

func player_is_running(is_running: bool):
	if is_running:
		step_delay = footstep_delay_running
	else:
		step_delay = footstep_delay
	
func _physics_process(delta):
	if just_landed():
		is_currently_landed = true
		play_footstep_sound()
		return
	
	# no moving, no footsteps
	if not is_moving() and not started_jumping():
		is_currently_moving = false
		is_currently_jumping = false
		footstep_timer = 0.0
		return
	
	if started_jumping():
		is_currently_jumping = true
		is_currently_landed = false
		play_footstep_sound()
		return
	
	# play first step, directly after the player starts moving
	if started_moving():
		is_currently_moving = true
		play_footstep_sound()
		return
	
	footstep_timer += delta
	if footstep_timer >= step_delay and is_moving():
		play_footstep_sound()
		footstep_timer = 0.0

func started_moving():
	var im = is_moving()
	return is_currently_moving != im and im

func started_jumping():
	var ij = is_jumping()
	return is_currently_jumping != ij and ij

func just_landed():
	var jl = parent_body.is_on_floor()
	return is_currently_landed != jl && jl

func is_moving():
	return parent_body.velocity.x != 0.0

func is_jumping():
	return not parent_body.is_on_floor() and parent_body.velocity.y < 0.0

func jumped_from_leafs():
	return started_jumping() && repulsor_area.is_touching_leaf()

func stands_on_leafs():
	return parent_body.is_on_floor() and repulsor_area.is_touching_leaf()

func stands_on_floor():
	return parent_body.is_on_floor() and not repulsor_area.is_touching_leaf()

func play_footstep_sound():
	# is the player standing on leafs or not?
	if stands_on_leafs() or jumped_from_leafs():
		# select a random steps sound
		var random_index = randi() % footstep_sounds_on_leafs.size()
		while random_index == last_footstep_sound_index:
			random_index = randi() % footstep_sounds_on_leafs.size()
		last_footstep_sound_index = random_index
		var sound = footstep_sounds_on_leafs[random_index]
		
		# set and play it
		SoundManager.instance.play(sound, 1.0)
