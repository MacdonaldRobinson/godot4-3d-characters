extends Node3D
class_name PlayableCharacter

@onready var anim_tree: AnimationTree = $AnimationTree

signal AnimationChanged(anim_tree: AnimationTree, delta: float)
var motion_direction: Vector2 = Vector2(0, 0)
var is_falling: bool = false
var is_jumping: bool = false
var is_on_floor: bool = true
var is_dying: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_motion(motion_direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if is_dying:
		return
		
	var animation_name: String = "";
	
	if not is_on_floor:		
		set_falling()	
	elif is_on_floor and not is_dying:
		if Input.is_action_pressed("forward"):
			motion_direction = lerp_vector(motion_direction, Vector2(0, 1))
			set_motion(motion_direction)
			
		elif Input.is_action_pressed("backward"):
			motion_direction = lerp_vector(motion_direction, Vector2(0, -1))
			set_motion(motion_direction)
			
		if Input.is_action_pressed("left"):
			motion_direction = lerp_vector(motion_direction, Vector2(-1, 0))
			set_motion(motion_direction)
			
		elif Input.is_action_pressed("right"):
			motion_direction = lerp_vector(motion_direction, Vector2(1, 0))
			set_motion(motion_direction)
		
		if Input.is_action_just_pressed("jump"):
			set_jumping(motion_direction)
			
		if not Input.is_anything_pressed():
			motion_direction = lerp_vector(motion_direction, Vector2(0, 0))
			set_motion(motion_direction)			
		
	AnimationChanged.emit(anim_tree, delta)
	
func set_is_on_floor(is_on_floor: bool):
	self.is_on_floor = is_on_floor
	
func set_falling():
	is_falling = true
	anim_tree.set("parameters/motion_state/transition_request", "falling")

func set_jumping(motion_direction: Vector2):
	is_falling = false	
	anim_tree.set("parameters/jump_direction/blend_position", motion_direction)
	anim_tree.set("parameters/jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func set_dying():
	is_dying = true	
	anim_tree.set("parameters/motion_state/transition_request", "dying")	

func set_motion(motion_direction: Vector2):
	is_falling = false
	anim_tree.set("parameters/motion_state/transition_request", "motion")
	anim_tree.set("parameters/motion/blend_position", motion_direction)
	
func get_motion_state():
	return anim_tree.get("parameters/motion_state/transition_request")
	
func lerp_vector(current_vector: Vector2, final_vector: Vector2) -> Vector2:
	var new_vector = lerp(motion_direction, final_vector, 0.1)
	return new_vector
