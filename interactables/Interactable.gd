extends Node3D
class_name Interactable

@export var item_name: String
@export var item_texture: Texture

@onready var interaction_point: Node3D = get_node("InteractionPoint")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(interacting_body):
	emit_signal("OnInteracting", interacting_body)
