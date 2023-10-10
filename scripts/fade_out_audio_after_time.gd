class_name FadeOutAudioAfterTime extends Node

@export var delay_before_fade_out: float = 5.0
@export var fade_out_duration: float = 3.0

func _ready():
	var fade_tween = create_tween()
	fade_tween.tween_interval(delay_before_fade_out)
	fade_tween.tween_property(get_parent(), "volume_db", -100, fade_out_duration)
