extends Control
class_name MainMenu

@export var overlays: Overlays

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()

func _on_character_selecter_pressed():
	GameState.game.load_character_selector()
	self.hide()
	GameState.release_mouse()
	GameState.game.overlays.hide_all_overlays()


func _on_settings_pressed() -> void:
	overlays.settings_overlay.show()

func _on_visibility_changed() -> void:	
	var current_scene = GameState.get_current_scene()
	if current_scene is MultiplayerScene:
		if self.visible:
			GameState.release_mouse()
		else:
			GameState.capture_mouse()
