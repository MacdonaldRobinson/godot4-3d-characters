extends SpringArm3D
class_name CameraController

@export var follow_node: Node3D
@export var character: Character

@onready var camera: Camera3D = $Camera3D
@onready var character_look_at_point: Node3D = $CharacterLookAtPoint
@onready var camera_floor_raycast: RayCast3D = $Camera3D/CameraFloorRayCast

var last_event:InputEvent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	self.add_excluded_object(camera)
	self.add_excluded_object(self)
	self.top_level = true


func _input(event: InputEvent) -> void:
	last_event = event 
	if not camera.current:
		return
	
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
		
	camera.global_position.y += 1
		
	self.add_excluded_object(character)	
	
	if character.alert_target:
		self.add_excluded_object(character.alert_target)
	
	
	if character.follow_target:
		self.add_excluded_object(character.follow_target)
		
	if character.interact_target:		
		self.add_excluded_object(character.interact_target)
	
	var character_animation: CharacterAnimations = character.character_animations
	
	if character.character_animations.is_dying():
		return
	
	if (Input.is_action_pressed("forward") or
		Input.is_action_pressed("backward") or
		Input.is_action_pressed("left") or 
		Input.is_action_pressed("right")):
			
		character.look_at(character_look_at_point.global_position)
		character.rotation.x = 0
		character.rotation.z = 0
		pass
	
	self.global_position = follow_node.global_position
	camera.look_at(follow_node.global_position)
