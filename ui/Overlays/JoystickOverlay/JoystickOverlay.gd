extends Control
class_name JoystickOverlay

@onready var player_joystick: VirtualJoystick = $PlayerJoystick
@onready var camera_joystick: VirtualJoystick = $CameraJoystick

@export var camera_controller: CameraController:
	get:
		return camera_controller
	set(value):
		if player_joystick.visible:
			camera_controller = value
	
func _process(delta: float) -> void:
	#print(camera_controller)
	#if camera_controller:
		#var angle = camera_joystick.output.angle()
		#camera_controller.rotate_y(angle / 100)
	pass
