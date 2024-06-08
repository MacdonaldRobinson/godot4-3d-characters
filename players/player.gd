extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var character: Character = $Amy

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()

func _on_animation_changed(anim_tree: AnimationTree) -> void:
	var root_motion_position =  anim_tree.get_root_motion_position()
	var root_motion_rotation = anim_tree.get_root_motion_rotation()
	var root_motion_position_acc = anim_tree.get_root_motion_position_accumulator() 

	root_motion_position.y = 0
	root_motion_rotation.x = 0
	root_motion_rotation.z = 0

	self.translate_object_local(root_motion_position)
	self.rotate_object_local(root_motion_rotation.get_axis().normalized(), root_motion_rotation.get_angle())	
		
