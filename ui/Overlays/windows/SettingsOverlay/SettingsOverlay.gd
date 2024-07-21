extends Control
class_name SettingsOverlay

@onready var settings_windows_popup: Window = $SettingsWindowPopup
@onready var settings_ui: SettingsUI = %Settings

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_scene = GameState.get_current_scene()
		
	if !settings_ui.level and current_scene and settings_ui and current_scene is Level:
		settings_ui.level = current_scene	
			
	pass


func _on_visibility_changed() -> void:
	if settings_windows_popup:
		if self.visible:
			settings_windows_popup.show()
		else:
			settings_windows_popup.hide()
		


func _on_settings_window_popup_close_requested() -> void:
	self.hide()
