extends StaticBody3D
class_name Door

@export var door_hindge: Node3D
@export var door_mesh: MeshInstance3D

@onready var interaction_area: InteractionArea = $CollisionShape3D/InteractionArea

var is_opened: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	var interacting_area: Area3D = interaction_area.get_overlapping_area_in_group()
		
	if Input.is_action_just_pressed("interact"):
		if interacting_area:
			if is_opened:
				close_door()
			else:
				open_door()		

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
