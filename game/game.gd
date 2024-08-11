extends Node3D
class_name Game

@onready var multiplayer_spawner: MultiplayerSpawner = %MultiplayerSpawner
@onready var multiplayer_spawn_scene: Node3D = %MultiPlayerSpawnScene
@onready var local_spawn_scene: Node3D = %LocalSpawnScene
@onready var overlays: Overlays = %Overlays

@export var lobby_scene: PackedScene
@export var character_selector_scene: PackedScene
@export var level_scene: PackedScene

@onready var lobby: Lobby = lobby_scene.instantiate()
@onready var character_selector: CharacterSelecter = character_selector_scene.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	GameState.game = self	
	load_character_selector()
	
	pass

func load_lobby():
	local_spawn_scene.show()
	multiplayer_spawn_scene.hide()
	
	for node in local_spawn_scene.get_children():
		local_spawn_scene.remove_child(node)

	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)
	
	if not lobby:
		lobby = lobby_scene.instantiate()
		
	if lobby:			
		local_spawn_scene.add_child(lobby)	
		
	GameState.game.overlays.joystick_overlay.show()
	GameState.game.overlays.chat_overlay.show()
	lobby.world_selecter.show()


func load_character_selector():	
	local_spawn_scene.show()
	multiplayer_spawn_scene.hide()
	
	GameState.game.overlays.hide_all_overlays()

	for node in local_spawn_scene.get_children():
		local_spawn_scene.remove_child(node)

	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)
		
	for node in local_spawn_scene.get_children():
		local_spawn_scene.remove_child(node)
	
	local_spawn_scene.add_child(character_selector)	
	
	GameState.release_mouse()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
