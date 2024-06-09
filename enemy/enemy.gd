extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var anim_tree: AnimationTree = $"Warrok W Kurniawan/AnimationTree"
@onready var alert_area: Area3D = $AlertArea
@onready var attack_area: Area3D = $AttackArea

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	anim_tree.set("parameters/motion_attack/transition_request", "motion")

	var alert_found_character: CharacterBody3D = null
	var attack_found_character: CharacterBody3D = null
	
	var alert_overlapping_bodies = alert_area.get_overlapping_bodies()	
	if alert_overlapping_bodies.size() != 0:
		
		for body in alert_overlapping_bodies:
			if body is CharacterBody3D:
				if body != self:
					alert_found_character = body
					break
					
	if alert_found_character:
		lerp_motion_animation(Vector2(0, 1))
	else:
		lerp_motion_animation(Vector2(0, 0))
		return
		
	var attack_overlapping_bodies = attack_area.get_overlapping_bodies()
		
	for body in attack_overlapping_bodies:
		if body is CharacterBody3D:
			if body != self:
				attack_found_character = body
				break
				
	if attack_found_character:
		attack()
						
	look_at_target(alert_found_character)
	apply_root_motion()

		
func lerp_motion_animation(new_value: Vector2):
	anim_tree.set("parameters/motion_attack/transition_request", "motion")		
	var current_value: Vector2 = anim_tree.get("parameters/motion/blend_position")	
	var lerp_val = lerp(current_value, new_value, 0.1)
	anim_tree.set("parameters/motion/blend_position", lerp_val)
	
func attack():
	var attacks:Array[String] = ["attack1"]
	var random_attack = attacks.pick_random()
	
	anim_tree.set("parameters/motion_attack/transition_request", "attack")	
	anim_tree.set("parameters/attacks/transition_request", random_attack)	
	
func look_at_target(target: Node3D):
	self.look_at(target.global_position, Vector3.UP, true)
	self.rotation.x = 0
	self.rotation.z = 0		
	
func apply_root_motion():
	var root_motion_position =  anim_tree.get_root_motion_position()
	var root_motion_rotation = anim_tree.get_root_motion_rotation()

	root_motion_position.y = 0
	root_motion_rotation.x = 0
	root_motion_rotation.z = 0
	
	var root_motion_rotation_normalized = root_motion_rotation.get_axis().normalized()

	self.translate_object_local(root_motion_position)
	
	if root_motion_rotation_normalized != Vector3.ZERO:
		self.rotate_object_local(root_motion_rotation_normalized, root_motion_rotation.get_angle())		
