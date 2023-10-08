class_name DestroyIfOffscreen extends VisibleOnScreenNotifier2D

@export var seconds_offscreen: float = 3.0
@export var destroy_parent: bool = true

var offscreen_timer: float = 0.0
var will_be_destroyed: bool = false

func _process(delta):
	if will_be_destroyed:
		return
	
	if not is_on_screen():
		offscreen_timer += delta
	else:
		offscreen_timer = 0.0

	if offscreen_timer >= seconds_offscreen:
		if destroy_parent:
			get_parent().queue_free()
		else:
			queue_free()
		will_be_destroyed = true
