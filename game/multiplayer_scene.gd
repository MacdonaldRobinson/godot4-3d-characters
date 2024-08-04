extends Node3D
class_name MultiplayerScene

@export var players_container:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.game.overlays.joystick_overlay.show()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
