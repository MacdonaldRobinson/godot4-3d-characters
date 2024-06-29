extends Node3D
class_name CharacterSelecter

@onready var characters_container: Node3D = $CharactersContainer
@onready var camera: Camera3D = $Camera3D
@onready var character_name: LineEdit = %Name as LineEdit

var selected_character: Character

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_character_signals();
	select_character(characters_container.get_child(0))
	

func setup_character_signals():
	for character in characters_container.get_children():
		if character is Character:
			select_character(character)
			#character.OnCharacterSelected.connect(
				#func(character): 
					#select_character(character)
			#)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	var new_character
	
	if Input.is_action_just_pressed("ui_left"):
		new_character = previous_character()		
		select_character(new_character)
	elif Input.is_action_just_pressed("ui_right"):
		new_character = next_character()
		select_character(new_character)
	
	
func previous_character():
	var selected_character_index = selected_character.get_index()
	
	if selected_character_index == 0:
		return
	
	var new_character: Character = characters_container.get_child(selected_character_index - 1)
	return new_character
	
func next_character():
	var selected_character_index = selected_character.get_index()
	var total_characters = characters_container.get_children().size()
	
	if selected_character_index == total_characters-1:
		return
		
	var new_character: Character = characters_container.get_child(selected_character_index + 1)

	return new_character

func select_character(character: Character):
	if not character:
		return
		
	selected_character = character	
	lookat_character(selected_character)
	
func lookat_character(character: Character):
	var tween = create_tween()
	var lookat = character.camera_controller.follow_node.global_position
	var new_camera_position = lookat - (Vector3.FORWARD * 2)
	
	tween.tween_property(camera, "global_position", new_camera_position, 1)

func _on_select_pressed():
	selected_character.character_stats.name = character_name.text
	GameState.set_my_player_character(selected_character)
	GameState.game.load_lobby()
