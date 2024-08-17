@tool

extends Area3D
class_name InteractionArea

@export var incoming_mesh_instance: MeshInstance3D
@onready var template_mesh: MeshInstance3D = $MeshInstance3D

var self_mesh_instance: MeshInstance3D 
var self_collision_shape: CollisionShape3D

signal OnInteract

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func get_overlapping_area_in_group(group_name: String = ""):
	var found_items = []
	for area in get_overlapping_areas():
		if group_name != "" and area.is_in_group(group_name):
			found_items.push_back(area)
		
		if area.is_in_group("interactable"):
			found_items.push_back(area)

	
	if found_items.size() > 0:
		return found_items[0]

func get_overlapping_bodies_in_group(group_name: String = ""):
	var found_items = []
	
	for body in get_overlapping_bodies():
		if group_name != "" and body.is_in_group(group_name):
			found_items.push_back(body)
		elif body.is_in_group("interactable"):
			found_items.push_back(body)

	if found_items.size() > 0:
		return found_items[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent() is not CollisionShape3D:
		return
		
	var incoming_collision_shape: CollisionShape3D = get_parent()

	if not self_collision_shape:		
		self_collision_shape = CollisionShape3D.new() 
		self_collision_shape.shape = incoming_collision_shape.shape.duplicate()

		add_child(self_collision_shape)
		
		self_collision_shape.top_level = false

	self_collision_shape.global_position = incoming_collision_shape.global_position
	self_collision_shape.global_rotation = incoming_collision_shape.global_rotation
	self_collision_shape.scale =  incoming_collision_shape.scale * Vector3(1.1, 1.1, 1.1)
		
	if not self_mesh_instance:
		self_mesh_instance = MeshInstance3D.new()
		self_mesh_instance.mesh = incoming_mesh_instance.mesh.duplicate()
		self_mesh_instance.top_level = true
		
		add_child(self_mesh_instance)
		
	if self_mesh_instance and self_mesh_instance.is_inside_tree():
		self_mesh_instance.global_position = incoming_mesh_instance.global_position
		self_mesh_instance.global_rotation = incoming_mesh_instance.global_rotation
		self_mesh_instance.rotation = incoming_mesh_instance.rotation
		
		self_mesh_instance.scale =  incoming_mesh_instance.scale * Vector3(1.1, 1.1, 1.1)
		
		self_mesh_instance.set_surface_override_material(0, template_mesh.mesh.surface_get_material(0))

		template_mesh.hide()

	pass


func _on_area_exited(area: Area3D) -> void:
	var interacting_area: Area3D = get_overlapping_area_in_group()

	if GameState.game and !interacting_area:
		GameState.game.overlays.interact_overlay.hide()
	
