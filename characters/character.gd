extends Node3D
class_name Character

@onready var anim_tree: AnimationTree = $AnimationTree

signal AnimationChanged(anim_tree: AnimationTree)
var motion_direction: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var animation_name: String = "";
	
	if Input.is_action_pressed("forward"):
		motion_direction = lerp_vector(motion_direction, Vector2(0, 1))
	elif Input.is_action_pressed("backward"):
		motion_direction = lerp_vector(motion_direction, Vector2(0, -1))
	
	if Input.is_action_pressed("left"):
		motion_direction = lerp_vector(motion_direction, Vector2(-1, 0))
	elif Input.is_action_pressed("right"):
		motion_direction = lerp_vector(motion_direction, Vector2(1, 0))
	
	if not Input.is_anything_pressed():
		motion_direction = lerp_vector(motion_direction, Vector2(0, 0))
		
	anim_tree.set("parameters/motion/blend_position", motion_direction)
	
	AnimationChanged.emit(anim_tree)

func lerp_vector(current_vector: Vector2, final_vector: Vector2) -> Vector2:
	var new_vector = lerp(motion_direction, final_vector, 0.1)
	return new_vector
