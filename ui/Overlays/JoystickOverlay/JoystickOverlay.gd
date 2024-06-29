extends Control
class_name JoystickOverlay

@onready var player_joystick: VirtualJoystick = $PlayerJoystick
@onready var camera_joystick: VirtualJoystick = $CameraJoystick

@export var camera_controller: CameraController:
	get:
		return camera_controller
	set(value):
		if player_joystick.visible:
			value.pause_rotation = true
			camera_controller = value
	
func _on_camera_joystick_gui_input(event):
	camera_controller.handle_rotation(event, true)


func _on_player_joystick_visibility_changed():
	pass
