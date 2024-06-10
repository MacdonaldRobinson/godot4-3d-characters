extends Node3D
class_name EnemyCharacter

@onready var anim_tree: AnimationTree = $AnimationTree

signal AttackFinished

var is_on_floor: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	 
	pass # Replace with function body.
	
func set_is_on_floor(is_on_floor: bool):
	self.is_on_floor = is_on_floor

func _process(delta: float) -> void:
	pass
		
func lerp_motion_animation(new_value: Vector2):
	anim_tree.set("parameters/motion_attack/transition_request", "motion")		
	var current_value: Vector2 = anim_tree.get("parameters/motion/blend_position")	
	var lerp_val = lerp(current_value, new_value, 0.1)
	anim_tree.set("parameters/motion/blend_position", lerp_val)

func idle():
	anim_tree.set("parameters/motion_attack/transition_request", "motion")	
	lerp_motion_animation(Vector2(0, 0))
	
func attack():
	var attacks:Array[String] = ["attack2"]
	var random_attack = attacks.pick_random()	
	
	anim_tree.set("parameters/motion_attack/transition_request", "attack")	
	anim_tree.set("parameters/attacks/transition_request", random_attack)
	
func attack_finished():
	AttackFinished.emit()
