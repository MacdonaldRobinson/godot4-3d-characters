extends Level
class_name Level2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_players.call_deferred()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
