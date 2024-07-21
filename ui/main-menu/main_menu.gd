extends Control
class_name MainMenuUI

@onready var exit_game: Button = %ExitGame
@onready var exit_game_confirmation_dialog: ConfirmationDialog = %ExitConfirmationDialog

signal GameSettingsClicked

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_exit_game_pressed() -> void:
	exit_game_confirmation_dialog.show()


func _on_game_settings_pressed() -> void:
	GameSettingsClicked.emit()


func _on_exit_confirmation_dialog_confirmed() -> void:
	get_tree().quit()

func _on_exit_confirmation_dialog_canceled() -> void:
	exit_game_confirmation_dialog.hide()


func _on_visibility_changed() -> void:
	if not is_inside_tree():
		return
		
	if self.visible:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_character_selecter_pressed() -> void:
	GameState.switch_to_character_selecter()
