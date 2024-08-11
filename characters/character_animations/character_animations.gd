extends Node3D
class_name CharacterAnimations

signal AnimationChanged(anim_tree: CharacterAnimations, delta: float)

var motion_direction: Vector2 = Vector2(0, 0)

var is_jumping: bool = false
var is_on_floor: bool = false

@onready var anim_tree: AnimationTree = $AnimationTree
@onready var anim_player: AnimationPlayer = $AnimationPlayer

@export var character: Character
@export var animation_tree: AnimationTree = anim_tree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Clara.hide()	
	set_motion(motion_direction)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		set_falling.rpc()	
		
	elif is_on_floor and not is_dying():
		var input_dir := Input.get_vector("left", "right", "forward", "backward")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()		

		if (Input.is_action_pressed("forward") or
			Input.is_action_pressed("backward") or
			Input.is_action_pressed("left") or
			Input.is_action_pressed("right")):
				motion_direction = lerp_vector(motion_direction, Vector2(direction.x, -direction.z))
				set_motion.rpc(motion_direction)
		#else:
			#motion_direction = lerp_vector(motion_direction, Vector2(0, 0))
			#set_motion.rpc(motion_direction)
			
		
		if Input.is_action_just_pressed("jump"):
			#attack_stance.rpc(false)
			set_jumping.rpc(motion_direction)
			
		if not Input.is_anything_pressed():
			motion_direction = lerp_vector(motion_direction, Vector2(0, 0))
			set_motion.rpc(motion_direction)
			
	#if self.get_parent().name != "1":
	AnimationChanged.emit(self, delta)	
	
func set_is_on_floor(is_on_floor: bool):
	self.is_on_floor = is_on_floor
	
@rpc("call_local", "any_peer")
func set_falling():
	anim_tree.set("parameters/motion_state/transition_request", "falling")

@rpc("call_local", "any_peer")
func set_jumping(motion_direction: Vector2):
	anim_tree.set("parameters/jump_direction/blend_position", motion_direction)
	anim_tree.set("parameters/jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
@rpc("call_local", "any_peer")
func set_dying():
	anim_tree.set("parameters/motion_state/transition_request", "dying")
	
@rpc("call_local", "any_peer")
func set_up_steps():
	anim_tree.set("parameters/motion_state/transition_request", "up_steps")	
	print("set_up_stairs", get_current_motion_state())
	
@rpc("call_local", "any_peer")
func set_down_stairs():
	anim_tree.set("parameters/motion_state/transition_request", "down_steps")
	
@rpc("call_local", "any_peer")
func set_motion(motion_direction: Vector2):		
	anim_tree.set("parameters/motion_state/transition_request", "motion")	
	anim_tree.set("parameters/motion/blend_position", motion_direction)
	
func lerp_vector(current_vector: Vector2, final_vector: Vector2) -> Vector2:
	var new_vector = lerp(motion_direction, final_vector, 0.1)
	return new_vector

@rpc("call_local","any_peer")
func lerp_motion_animation(new_value: Vector2):
	anim_tree.set("parameters/motion_state/transition_request", "motion")		
	var current_value: Vector2 = anim_tree.get("parameters/motion/blend_position")	
	var lerp_val = lerp(current_value, new_value, 0.1)
	anim_tree.set("parameters/motion/blend_position", lerp_val)

@rpc("call_local", "any_peer")
func idle():
	if not multiplayer:
		return
		
	if character.name != str(multiplayer.get_remote_sender_id()):
		return
		
	anim_tree.set("parameters/motion_state/transition_request", "motion")	
	lerp_motion_animation(Vector2(0, 0))	

func is_attacking():
	var current_motion_state = get_current_motion_state()
	return current_motion_state == "attacking"	

func is_dying():
	var current_motion_state = get_current_motion_state()
	return current_motion_state == "dying"
	
func is_steps():
	var current_motion_state = get_current_motion_state()
	return current_motion_state.contains("steps")

func is_falling():
	var current_motion_state = get_current_motion_state()
	return current_motion_state == "falling"
	
func get_current_motion_state() -> String:
	if not anim_tree:
		return ""
		
	var current_motion_state = anim_tree.get("parameters/motion_state/current_state")
	return current_motion_state

@rpc("call_local", "any_peer")
func attack_stance(auto_attack: bool):
	anim_tree.set("parameters/motion_state/transition_request", "attacking")
	
	if auto_attack:
		#print(character.name, get_current_motion_state())
		var attack_state: Array[String] =["state_0", "state_1", "state_2", "state_3"]
		var random_attack_state: String = attack_state.pick_random()
		attack.rpc(random_attack_state, auto_attack)
			
	if auto_attack:
		return
		
	#print(multiplayer.get_unique_id(), "=", multiplayer.get_remote_sender_id())

	if (Input.is_action_pressed("forward") or
		Input.is_action_pressed("backward") or
		Input.is_action_pressed("left") or
		Input.is_action_pressed("right")):
			idle.rpc()
			return
	
	if auto_attack:
		return

	if Input.is_action_pressed("attack1"):
		var attack_state: Array[String] =["state_0", "state_1", "state_2", "state_3"]
		var random_attack_state: String = attack_state.pick_random()
		
		if is_multiplayer_authority():
			attack.rpc(random_attack_state, auto_attack)
		
	elif Input.is_action_pressed("attack2"):	
		var attack_state: Array[String] =["state_4"]
		var random_attack_state: String = attack_state.pick_random()
		if is_multiplayer_authority():
			attack.rpc(random_attack_state, auto_attack)

@rpc("call_local", "any_peer")
func attack(attack_state: String, auto_attack: bool):
	var is_activly_attacking = anim_tree.get("parameters/motion_attack/active")

	if is_activly_attacking:
		return
		
	anim_tree.set("parameters/attack_state/transition_request", attack_state)
	anim_tree.set("parameters/motion_attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)	
	
func playing_dying_animation():
	character.dying_sound.play()

func attack_damage(damage_amount: int):
	character.attack_damage.rpc(damage_amount)
