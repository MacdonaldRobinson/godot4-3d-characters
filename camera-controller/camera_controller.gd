extends SpringArm3D

@export var follow_node: Node3D
@onready var camera: Camera3D = $Camera3D

func _input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	
	if event is InputEventMouseMotion:			
		var normalized = event.screen_relative.normalized() / 30		
		self.rotate_y(-normalized.x)		
		camera.rotate_x(-normalized.y)
		
		if camera.rotation.x < -1:
			camera.rotation.x = -1

		if camera.rotation.x > 1:
			camera.rotation.x = 1
			
	if event is InputEventMouseButton:
		var tween: Tween = self.create_tween()
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var to_val = self.spring_length - 0.5
			if to_val < 1:
				to_val = 1
				
			tween.tween_property(self, "spring_length", to_val, 0.1)
				
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var to_val = self.spring_length + 0.5
			
			if to_val > 3:
				to_val = 3

			tween.tween_property(self, "spring_length", to_val, 0.1)
			
func _process(delta: float) -> void:
	self.global_position = follow_node.global_position
	
	if Input.is_anything_pressed():
		
		if Input.is_action_pressed("left"):
			return
		
		if Input.is_action_pressed("right"):
			return
		
		follow_node.get_parent().look_at(camera.global_position)
		follow_node.get_parent().rotation.x = 0
		follow_node.get_parent().rotation.z = 0			
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
