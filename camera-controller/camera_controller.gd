extends SpringArm3D
class_name CameraController

@export var follow_node: Node3D
@export var character: Character

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.top_level = true

func _input(event: InputEvent) -> void:
	
	if not camera.current:
		return
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED	
	
	if event is InputEventMouseMotion:
		var normalized = event.screen_relative.normalized() / 30		
		self.rotate_y(-normalized.x)		
		camera.rotate_x(-normalized.y)
		
		if camera.rotation.x < -0.5:
			camera.rotation.x = -0.5

		if camera.rotation.x > 0.5:
			camera.rotation.x = 0.5
			
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var tween: Tween = self.create_tween()
			var to_val = self.spring_length - 0.5
			if to_val < 1:
				to_val = 1
				
			tween.tween_property(self, "spring_length", to_val, 0.1)
				
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var tween: Tween = self.create_tween()
			var to_val = self.spring_length + 0.5
			
			if to_val > 5:
				to_val = 5

			tween.tween_property(self, "spring_length", to_val, 0.1)
			
func _process(delta: float) -> void:
	if not camera.current:
		return
	
	var character_animation: CharacterAnimations = character.character_animations
	
	var can_follow = false
	
	camera.look_at(follow_node.global_position)
	
	if self.global_position.distance_to(follow_node.global_position) > 0.05:
		can_follow = true
	
	if character.character_animations.is_dying():
		return
					
	self.global_position = follow_node.global_position

	if Input.is_anything_pressed():		
		character.look_at(camera.global_position)
		character.rotation.x = 0
		character.rotation.z = 0
		
	if can_follow:	
		pass
		#self.global_position = lerp(self.global_position, follow_node.global_position, 0.05)
