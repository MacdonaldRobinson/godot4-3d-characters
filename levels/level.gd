extends MultiplayerScene
class_name Level

@export var level_music: AudioStreamPlayer
@export var screen_ui: ScreenUI
@onready var players: Node3D = %Players

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
