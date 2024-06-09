extends CharacterBody3D
class_name Enemy

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var enemy_character: EnemyCharacter = $"Warrok W Kurniawan"

@onready var alert_area: Area3D = $AlertArea
@onready var interact_area: Area3D = $InteractArea
@onready var follow_area: Area3D = $FollowArea

var nodes_in_alert_area: Array[Node3D] = []
var nodes_in_interact_area: Array[Node3D] = []
var nodes_in_follow_area: Array[Node3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	
func _process(delta: float) -> void:
	enemy_character.set_is_on_floor(is_on_floor())

	nodes_in_alert_area = alert_area.get_overlapping_bodies()
	nodes_in_interact_area = interact_area.get_overlapping_bodies()
	nodes_in_follow_area = follow_area.get_overlapping_bodies()
	
	var target = null
	
	for node in nodes_in_alert_area:
		if node.name != self.name:
			if node is Player:
				target = node
				look_at_target(node)
				break
				
	for node in nodes_in_follow_area:
		if node.name != self.name:
			if node is Player:
				target = node
				enemy_character.lerp_motion_animation(Vector2(0, 1))
				break				
				
	for node in nodes_in_interact_area:
		if node.name != self.name:
			if node is Player:
				target = node
				enemy_character.attack()
				break
	
	if target == null:
		enemy_character.idle()
	
	apply_root_motion()	
	
func look_at_target(target: Node3D):
	if target.global_position == self.global_position:
		return		
		
	self.look_at(target.global_position, Vector3.UP, true)
	self.rotation.x = 0
	self.rotation.z = 0	

func apply_root_motion():
	var root_motion_position =  enemy_character.anim_tree.get_root_motion_position()
	var root_motion_rotation = enemy_character.anim_tree.get_root_motion_rotation()

	root_motion_position.y = 0
	root_motion_rotation.x = 0
	root_motion_rotation.z = 0
	
	var root_motion_rotation_normalized = root_motion_rotation.get_axis().normalized()

	self.translate_object_local(root_motion_position)
	
	if root_motion_rotation_normalized != Vector3.ZERO:
		self.rotate_object_local(root_motion_rotation_normalized, root_motion_rotation.get_angle())		
	
func _on_warrok_w_kurniawan_attack_finished() -> void:
	for node in nodes_in_interact_area:
		if node.name != self.name:
			if node is Player:
				node.take_damage(10)
				break		
