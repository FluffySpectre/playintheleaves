class_name SoundTriggerArea extends Area2D

@export var sounds: Array[AudioStream]

var last_sound_index: int = -1

func _ready():
	body_entered.connect(on_body_entered)
	
func on_body_entered(body):
	if body.name == "Player":
		play_sound()

func play_sound():
	var sound_index = randi() % sounds.size()
	while sound_index == last_sound_index:
		sound_index = randi() % sounds.size()
	last_sound_index = sound_index

	var sound = sounds[sound_index]
	SoundManager.instance.play(sound)
