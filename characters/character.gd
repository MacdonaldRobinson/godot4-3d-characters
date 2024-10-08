extends CharacterBody3D
class_name Character

var gravity: int = 9.8

@onready var health_bar_3d: HealthBar3D = $HealthBar
@onready var floor_check: RayCast3D = $FloorCheckRayCast
@onready var camera_controller: CameraController = $CameraController
@onready var levelup_effect: LevelUpEffect = $LevelUpEffect

@onready var character_animations: CharacterAnimations = $CharacterAnimations
@onready var alert_area: Area3D = $AlertArea
@onready var interact_area: Area3D = $InteractArea
@onready var follow_area: Area3D = $FollowArea
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var character_name: Label3D = %Name

var nodes_in_alert_area: Array[Node3D] = []
var nodes_in_interact_area: Array[Node3D] = []
var nodes_in_follow_area: Array[Node3D] = []

signal OnClicked(character: Character)

@export var level: Level
@export var character_stats: CharacterStats:
	set(value):
		character_stats = value
		
		if not health_bar_3d:
			await ready
						
		if health_bar_3d and character_stats:
			health_bar_3d.character = self
			health_bar_3d.health_bar.progress_bar.value = character_stats.current_health
			health_bar_3d.health_bar.progress_bar.max_value = character_stats.max_health
			
			character_name.text = character_stats.name
			
			if not character_stats.LeveledUp.is_connected(character_leveled_up):
				character_stats.LeveledUp.connect(character_leveled_up)
		
@export var dying_sound: AudioStreamPlayer3D

func character_leveled_up():		
	if level and level.level_music.playing:
		level.level_music.stop()	
	
	levelup_effect.play_levelup_effect()
	
	levelup_effect.animation_player.animation_finished.connect(
		func(anim):			
			if GameState.game.overlays.settings_overlay.settings_ui.background_music.button_pressed:
				level.level_music.play()			
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not multiplayer.has_multiplayer_peer():
		return
		
	if not is_multiplayer_authority():
		return
			
	nodes_in_alert_area = alert_area.get_overlapping_bodies()
	nodes_in_interact_area = interact_area.get_overlapping_bodies()
	nodes_in_follow_area = follow_area.get_overlapping_bodies()
	
	for area in alert_area.get_overlapping_areas():
		nodes_in_alert_area.push_back(area)
	
	for area in interact_area.get_overlapping_areas():
		nodes_in_interact_area.push_back(area)
	
	for area in follow_area.get_overlapping_areas():
		nodes_in_follow_area.push_back(area)

	apply_root_motion(delta)
		
	velocity.y -= gravity
	
	move_and_slide()	
	
func get_node_in_alert_area(group_name:String = ""):
	if nodes_in_alert_area.size() > 0:
		for node in nodes_in_alert_area:
			if node == self:
				continue
					
			if node is Character:
				if node.character_animations.is_dying():
					continue
				else:
					return node		
				
			if node.is_in_group(group_name):
				return node		
	return null
	
func get_node_in_interact_area(group_name:String = ""):	
	if nodes_in_interact_area.size() > 0:	
		for node in nodes_in_interact_area:
			if node == self:
				continue

			if node.is_in_group("interactable"):				
				return node
					
			if node is Character:
				if node.character_animations.is_dying():
					continue	
				else:
					return node								
					
			if node.is_in_group(group_name):
				return node

	return null	
	
func get_node_in_follow_area(group_name:String = ""):
	if nodes_in_follow_area.size() > 0:
		for node in nodes_in_follow_area:
			if node == self:
				continue
				
			if node is Character:
				if node.character_animations.is_dying():
					continue
				else:
					return node						
				
			if node.is_in_group(group_name):
				return node		
		
	return null		

func look_at_target(target: Character):	
	if target.global_position == self.global_position:
		return		

	self.look_at(target.global_position, Vector3.UP, true)
	self.rotation.x = 0
	self.rotation.z = 0	

func apply_root_motion(delta):
	var root_motion_position =  character_animations.anim_tree.get_root_motion_position()
	var root_motion_rotation = character_animations.anim_tree.get_root_motion_rotation()
	
	var root_motion_rotation_normalized = root_motion_rotation.get_axis().normalized()

	self.translate_object_local(root_motion_position)	

	if root_motion_rotation_normalized != Vector3.ZERO:
		self.rotate_object_local(root_motion_rotation_normalized, root_motion_rotation.get_angle())		
		
	GameState.sync_node.rpc(self.get_path(), { "position": self.position, "rotation": self.rotation} )

@rpc("call_local","any_peer")
func take_damage(damage_amount: int):
	if health_bar_3d.character:
		health_bar_3d.decrease_health_by(damage_amount)

func attack_damage(damage_amount: int):
	var interact_target = get_node_in_interact_area()
	
	if interact_target and interact_target is Character:
		interact_target.take_damage.rpc(damage_amount)
		character_stats.experiance_points += damage_amount
				
		if interact_target.character_stats:
			if interact_target.character_stats.current_health == 0:
				character_stats.number_of_killes += 1


func _on_interact_area_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			print(event, self.name)	


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			OnClicked.emit(self)
