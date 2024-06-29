extends Node
class_name Game

@onready var screen_ui: ScreenUI = %ScreenUI
@onready var multiplayer_spawn_scene: Node = %MultiPlayerSpawnScene

@export var lobby_scene: PackedScene
@export var character_selector_scene: PackedScene
@export var level_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var my_player: Character = GameState.create_character()
	GameState.multiplayer_spawn_scene = multiplayer_spawn_scene
	GameState.game = self	
	GameState.set_my_player_character(my_player)

	load_character_selector()
	
	pass

func load_lobby():
	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)

	var lobby: Lobby = lobby_scene.instantiate()
	
	multiplayer_spawn_scene.add_child(lobby)
	

func load_character_selector():
	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)

	var character_selector: CharacterSelecter = character_selector_scene.instantiate()

	multiplayer_spawn_scene.add_child(character_selector)
	
func add_player_to_lobby():
	pass
	#var character: Character = create_character()
	#lobby.players_container.add_child(character)
	
	
func add_player_to_level():
	var character: Character = GameState.create_character()
	
	var level:Level = level_scene.instantiate()	
	level.screen_ui = screen_ui
		
	multiplayer_spawn_scene.add_child(level)
	
	level.players.add_child(character)

	character.level = level
	screen_ui.level = level
	
	character.camera_controller.camera.current = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
