extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var character: PlayableCharacter = $Amy
@onready var health_bar: HealthBar = $HealthBar/SubViewport/HealthBar

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	character.set_is_on_floor(is_on_floor())

	if health_bar.progress_bar.value == 0:
		character.set_dying()
				
	move_and_slide()
	
func take_damage(damage_amount: int):
	health_bar.decrease_health_by(damage_amount)

func _on_animation_changed(anim_tree: AnimationTree, delta: float) -> void:
	var root_motion_position =  anim_tree.get_root_motion_position()
	var root_motion_rotation = anim_tree.get_root_motion_rotation()
	
	self.translate_object_local(root_motion_position)	
	self.rotate_y(root_motion_rotation.y)
	#self.rotate_object_local(root_motion_rotation.get_axis().normalized(), root_motion_rotation.get_angle())		
	
