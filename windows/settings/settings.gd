extends Control
class_name SettingsUI

@onready var background_music: CheckBox = %BackgroundMusic
@export var level: Level:
	get:
		return level
	set(value):
		level = value
		background_music.button_pressed = level.level_music.playing

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_background_music_pressed() -> void:
	level.level_music.playing = background_music.button_pressed
