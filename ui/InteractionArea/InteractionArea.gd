@tool
extends Area3D

@export var door_hindge: Node3D
@onready var interaction_indicator: Sprite3D = $InteractionIndicator
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

var is_opened: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var overlapping_bodies = self.get_overlapping_bodies()
	
	if door_hindge and collision_shape.shape is BoxShape3D:		
		$MeshInstance3D.mesh.size = collision_shape.shape.size
		$MeshInstance3D.global_position = collision_shape.global_position
		$MeshInstance3D. global_rotation = collision_shape.global_rotation
	
	for overlapping_body in overlapping_bodies:
		if overlapping_body is Character:
			if Input.is_action_just_pressed("interact"):
				if is_opened:
					close_door()
				else:
					open_door()	
	pass
	
func open_door():
	if door_hindge:
		var tweener: Tween = create_tween()
		tweener.tween_property(door_hindge, "rotation", Vector3(door_hindge.rotation.x, door_hindge.rotation.y, -1.5), 0.1)
		tweener.play()
		is_opened = true

func close_door():
	if door_hindge:
		var tweener: Tween = create_tween()
		tweener.tween_property(door_hindge, "rotation", Vector3(door_hindge.rotation.x, door_hindge.rotation.y, 0), 0.1)
		tweener.play()
		is_opened = false
