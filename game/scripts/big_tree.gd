class_name BigTree extends Node2D

@export var fade_speed: float = 1.0
@export var growl_sounds: Array[AudioStream]

var anger_level: int = 0
var last_anger_level: int = 0
var last_played_growl_index: int = -1

@onready var tree_sprite_normal: Sprite2D = $NormalSprite2D
@onready var tree_sprite_middle: Sprite2D = $MiddleSprite2D
@onready var tree_sprite_angry: Sprite2D = $AngrySprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if anger_level == 2:
    tree_sprite_middle.modulate.a = lerp(tree_sprite_middle.modulate.a, 0.0, delta * fade_speed)
  elif anger_level == 1:
    tree_sprite_normal.modulate.a = lerp(tree_sprite_normal.modulate.a, 0.0, delta * fade_speed)
  elif anger_level == 0:
    tree_sprite_normal.modulate.a = lerp(tree_sprite_normal.modulate.a, 1.0, delta * fade_speed)
    tree_sprite_middle.modulate.a = lerp(tree_sprite_middle.modulate.a, 1.0, delta * fade_speed)

  if anger_level != last_anger_level:
    last_anger_level = anger_level
    play_growl()
    
func play_growl():
  # select a random steps sound
  var sound_index = randi() % growl_sounds.size()
  while sound_index == last_played_growl_index:
    sound_index = randi() % growl_sounds.size()
  last_played_growl_index = sound_index
  SoundManager.instance.play(growl_sounds[sound_index])
  
