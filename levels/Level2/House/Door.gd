extends StaticBody3D
class_name Door

@export var door_hindge: Node3D
@export var door_mesh: MeshInstance3D
@export var interaction_area: InteractionArea

var is_opened: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_interact():
	if is_opened:
		close_door.rpc()
	else:
		open_door.rpc()

func _process(delta: float) -> void:
	var interacting_area: Area3D = interaction_area.get_overlapping_area_in_group()
	
	if not interaction_area.OnInteract.is_connected(_on_interact):
		interaction_area.OnInteract.connect(_on_interact)

@rpc("call_local", "any_peer")
func open_door():
	if door_hindge:
		var tweener: Tween = create_tween()
		tweener.tween_property(door_hindge, "rotation", Vector3(door_hindge.rotation.x, door_hindge.rotation.y, -1.5), 0.1)
		tweener.play()
		is_opened = true

@rpc("call_local", "any_peer")
func close_door():
	if door_hindge:
		var tweener: Tween = create_tween()
		tweener.tween_property(door_hindge, "rotation", Vector3(door_hindge.rotation.x, door_hindge.rotation.y, 0), 0.1)
		tweener.play()
		is_opened = false
