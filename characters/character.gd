extends CharacterBody3D
class_name Character

var gravity: int = 9.8

@export var camera_lookat_point: Node3D

@onready var health_bar_3d: HealthBar3D = $HealthBar
@onready var floor_check: RayCast3D = $FloorCheckRayCast
@onready var camera_controller: CameraController = $CameraController
@onready var levelup_effect: LevelUpEffect = $LevelUpEffect

@onready var character_animations: CharacterAnimations = $CharacterAnimations
@onready var alert_area: Area3D = $AlertArea
@onready var interact_area: Area3D = $InteractArea
@onready var follow_area: Area3D = $FollowArea
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var nodes_in_alert_area: Array[Node3D] = []
var nodes_in_interact_area: Array[Node3D] = []
var nodes_in_follow_area: Array[Node3D] = []

var alert_target: Character = null
var follow_target: Character = null
var interact_target: Character = null

@export var level: Level
@export var character_stats: CharacterStats = CharacterStats.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar_3d.current_health = character_stats.current_health
	health_bar_3d.max_health = character_stats.max_health
	character_stats.LeveledUp.connect(character_leveled_up)
	pass # Replace with function body.

func character_leveled_up():
	print("LevelUp")
	level.level_music.stop()	

	levelup_effect.play_levelup_effect()
	levelup_effect.animation_player.animation_finished.connect(
		func(anim):
			level.level_music.play()
			pass
	)

func _physics_process(delta: float) -> void:
	character_animations.set_is_on_floor(true)
	
#	if !floor_check.is_colliding():
	velocity.y -= gravity
		
	move_and_slide()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	follow_target = null
	interact_target = null
	alert_target = null
	
	nodes_in_alert_area = alert_area.get_overlapping_bodies()
	nodes_in_interact_area = interact_area.get_overlapping_bodies()
	nodes_in_follow_area = follow_area.get_overlapping_bodies()

	for node in nodes_in_alert_area:
		if node.name != self.name:
			if node is Character:
				if node.character_animations.is_dying():
					break
					
				follow_target = null
				interact_target = null
				alert_target = node				
				break
				
	for node in nodes_in_follow_area:
		if node.name != self.name:
			if node is Character:
				if node.character_animations.is_dying():
					break
				
				interact_target = null
				alert_target = null
				follow_target = node
				break
				
	for node in nodes_in_interact_area:
		if node.name != self.name:
			if node is Character:
				if node.character_animations.is_dying():
					break
									
				alert_target = null
				follow_target = null
				interact_target = node				
				break
				
	if not character_animations.is_dying():
		if not camera_controller.camera.current:
			if alert_target:
				look_at_target(alert_target)		
			elif follow_target:
				look_at_target(follow_target)			
				character_animations.lerp_motion_animation(Vector2(0, 1))
			elif interact_target:	
				look_at_target(interact_target)
				character_animations.attack_stance(true)
			else:
				character_animations.idle()			
		else:
			if interact_target:	
				character_animations.attack_stance(false)						
		
				
	if interact_target and interact_target.character_animations.is_dying():
		character_animations.idle()
	
	if health_bar_3d.health_bar.progress_bar.value == 0:
		character_animations.set_dying()

	apply_root_motion()
	update_character_stats()

				
func look_at_target(target: Node3D):
	if target.global_position == self.global_position:
		return		
		
	self.look_at(target.global_position, Vector3.UP, true)
	self.rotation.x = 0
	self.rotation.z = 0	

func update_character_stats():
	character_stats.current_health = health_bar_3d.current_health

func apply_root_motion():
	var root_motion_position =  character_animations.anim_tree.get_root_motion_position()
	var root_motion_rotation = character_animations.anim_tree.get_root_motion_rotation()
	
	var root_motion_rotation_normalized = root_motion_rotation.get_axis().normalized()
	
	self.translate_object_local(root_motion_position)
	
	if root_motion_rotation_normalized != Vector3.ZERO:
		self.rotate_object_local(root_motion_rotation_normalized, root_motion_rotation.get_angle())		

func take_damage(damage_amount: int):
	health_bar_3d.decrease_health_by(damage_amount)
	character_stats.current_health = health_bar_3d.current_health

func attack_damage(damage_amount: int):
	if interact_target:
		interact_target.take_damage(damage_amount)
		character_stats.experiance_points += damage_amount

		if interact_target.character_stats.current_health == 0:
			character_stats.number_of_killes += 1
