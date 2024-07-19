extends Node
class_name Game

@onready var multiplayer_spawner: MultiplayerSpawner = %MultiplayerSpawner
@onready var multiplayer_spawn_scene: Node = %MultiPlayerSpawnScene

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
	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)

	multiplayer_spawn_scene.add_child(lobby)	
	
	NetworkState.peer = null	
	
	lobby.reset_lobby()
	

func load_character_selector():	
	var my_player_info: PlayerInfo = GameState.get_my_player_info()
	
	if my_player_info:
		GameState.remove_player.rpc(my_player_info.peer_id)
	
	GameState.all_players_info.clear()
	
	for node in multiplayer_spawn_scene.get_children():
		multiplayer_spawn_scene.remove_child(node)
			
	multiplayer_spawn_scene.add_child(character_selector)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
