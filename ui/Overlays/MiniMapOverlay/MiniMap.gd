extends Control
class_name MiniMapOverlay

@export var follow_node: Node3D

@onready var camera: Camera3D = %MiniMapCam
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

# Called when the node enters the scene tree for the first time.
func _ready():
	if not follow_node:
		return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if camera and follow_node:
		camera.global_position.x = follow_node.global_position.x
		camera.global_position.y = (follow_node.global_position.y + 10)
		camera.global_position.z = follow_node.global_position.z 		
		
		var viewport_size = get_viewport_rect().size;
		
		sub_viewport.size = Vector2(viewport_size.x / 3, viewport_size.y / 3)
				
	pass
		
