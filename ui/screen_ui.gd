extends Control
class_name ScreenUI

@onready var hud:HudOverlay = %Hud
@onready var settings:SettingsUI = %Settings
@onready var main_menu:MainMenuUI = %MainMenu

@onready var settings_window_popup: Window = $Control/SettingsWindowPopup

# Called when the node enters the scene tree for the first time.
@export var character: Character:
	get:
		return character	
	set(value):
		character = value
   		
		if not is_node_ready():
			await ready		
			
		character.camera_controller.camera.current = true
		hud.character = character
		
@export var level: Level:
	get:
		return level	
	set(value):
		level = value
   		
		if not is_node_ready():
			await ready		
			
		settings.level = level		


func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("mouse_capture"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("main_menu_toggle"):
		if main_menu.visible:
			main_menu.hide()
		else:
			main_menu.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_menu_game_settings_clicked() -> void:
	settings_window_popup.show()


func _on_settings_window_popup_close_requested() -> void:
	settings_window_popup.hide()
