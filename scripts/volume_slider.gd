class_name VolumeSlider extends HSlider

@export var audio_bus_name: String = "Master"

@onready var bus: int = AudioServer.get_bus_index(audio_bus_name)

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	
	print(audio_bus_name + " volume = " + str(value))
	
	connect("value_changed", on_value_changed)
	connect("mouse_exited", release_focus)

func on_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
