extends ColorRect
class_name DeadOverlay

@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	pass
	
func show_overlay():
	if not anim_player.is_playing():
		anim_player.play("Overlay")
