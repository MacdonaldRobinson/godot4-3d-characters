extends Node3D
class_name CharacterAnimations

signal AnimationChanged(anim_tree: CharacterAnimations, delta: float)

var motion_direction: Vector2 = Vector2(0, 0)

var is_jumping: bool = false
var is_on_floor: bool = false

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Clara.hide()	
	set_motion(motion_direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not multiplayer.has_multiplayer_peer():
		return
		
	if not is_multiplayer_authority():
		return	

	if not character:
		return
		
	var my_player_info = GameState.get_my_player_info()
	
	if not my_player_info or str(my_player_info.peer_id) != character.name:
		return

	if is_dying():
		return
		
	var animation_name: String = "";
	
	if not is_on_floor:		
		set_falling()	
		
	elif is_on_floor and not is_dying():
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
		
	AnimationChanged.emit(self, delta)	
	
func set_is_on_floor(is_on_floor: bool):
	self.is_on_floor = is_on_floor
	
func set_falling():
	anim_tree.set("parameters/motion_state/transition_request", "falling")

func set_jumping(motion_direction: Vector2):
	anim_tree.set("parameters/jump_direction/blend_position", motion_direction)
	anim_tree.set("parameters/jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
func set_dying():
	anim_tree.set("parameters/motion_state/transition_request", "dying")
	
func set_motion(motion_direction: Vector2):
	anim_tree.set("parameters/motion_state/transition_request", "motion")	
	anim_tree.set("parameters/motion/blend_position", motion_direction)
	
func lerp_vector(current_vector: Vector2, final_vector: Vector2) -> Vector2:
	var new_vector = lerp(motion_direction, final_vector, 0.1)
	return new_vector

func lerp_motion_animation(new_value: Vector2):
	anim_tree.set("parameters/motion_state/transition_request", "motion")		
	var current_value: Vector2 = anim_tree.get("parameters/motion/blend_position")	
	var lerp_val = lerp(current_value, new_value, 0.1)
	anim_tree.set("parameters/motion/blend_position", lerp_val)

func idle():
	anim_tree.set("parameters/motion_state/transition_request", "motion")	
	lerp_motion_animation(Vector2(0, 0))	

func is_attacking():
	var current_motion_state = get_current_motion_state()
	var is_attack_stance: bool = (current_motion_state == "attacking")	
	var is_attacking = anim_tree.get("parameters/motion_attack/active")

	return is_attack_stance and is_attacking
		
func is_dying():
	var current_motion_state = get_current_motion_state()
	return current_motion_state == "dying"

func is_falling():
	var current_motion_state = get_current_motion_state()
	return current_motion_state == "falling"
	
func get_current_motion_state():
	var current_motion_state = anim_tree.get("parameters/motion_state/current_state")
	return current_motion_state

func attack_stance(auto_attack: bool):
	anim_tree.set("parameters/motion_state/transition_request", "attacking")
	
	if !is_attacking() and auto_attack:
		var attack_state: Array[String] =["state_0", "state_1", "state_2", "state_3"]
		var random_attack_state: String = attack_state.pick_random()
		attack(random_attack_state)
			
	if auto_attack:
		return

	if (Input.is_action_pressed("forward") or
		Input.is_action_pressed("backward") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")):
			idle()
			return
	
	if is_attacking():
		return

	if Input.is_action_pressed("attack1"):
		var attack_state: Array[String] =["state_0", "state_1", "state_2", "state_3"]
		var random_attack_state: String = attack_state.pick_random()
		attack(random_attack_state)
		
	elif Input.is_action_pressed("attack2"):	
		var attack_state: Array[String] =["state_4"]
		var random_attack_state: String = attack_state.pick_random()
		attack(random_attack_state)

func attack(attack_state: String):
	anim_tree.set("parameters/attack_state/transition_request", attack_state)
	anim_tree.set("parameters/motion_attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)	

func playing_dying_animation():
	character.dying_sound.play()

func attack_damage(damage_amount: int):
	character.attack_damage(damage_amount)
