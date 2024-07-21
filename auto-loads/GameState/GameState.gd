extends Node

var is_game_started: bool = false
var inventory: Inventory = Inventory.new() as Inventory
var chat_messages: Array[ChatMessage]

@export var all_players_info: Array[PlayerInfo]
@onready var scene_loader: SceneLoader = %SceneLoader
@export var game: Game

var player_scene: PackedScene = preload("res://characters/character.tscn")
	
signal OnPlayerAdded(player_info: PlayerInfo)
signal OnPlayerRemoved(player_info: PlayerInfo)
signal OnPlayerUpdated(player_info: PlayerInfo)
signal OnChatMessageAdded(chat_message: ChatMessage)

func _ready():
	scene_loader.hide()
	
	if is_headless_server():
		print("headless server mode, starting server on port 54210 ...")
		#var character:Character = load("res://animated-characters/Clara/Clara.tscn").instantiate()
		#GameState.set_my_player_character(character)
		var ip = NetworkState.create_server(54210)
		print("Hosting on: " + str(ip))
		
func create_character() -> Character:
	var character: Character = player_scene.instantiate()
	character.character_stats = CharacterStats.new()
	character.character_stats.name = "Player 1"
	character.character_stats.current_health = 10
	character.character_stats.current_level = 1
	character.character_stats.max_health = 100

	return character		
		
func set_my_player_character(selected_character: Character):
	var my_player_info: PlayerInfo = get_my_player_info()
	
	if not my_player_info:
		my_player_info = PlayerInfo.new()
		my_player_info.peer_id = multiplayer.get_unique_id()
		
	my_player_info.character_stats = selected_character.character_stats
	my_player_info.character_scene_file_path = selected_character.scene_file_path
	
	GameState.add_or_update_player_info(var_to_str(my_player_info))
	

func set_my_player_character_name(my_character_name: String):
	var my_player_info: PlayerInfo = get_my_player_info()
	my_player_info.character_name = my_character_name
	
	GameState.add_or_update_player_info(var_to_str(my_player_info))

func switch_to_scene(new_scene_path: String, callback: Callable = func(arg): pass):
	var current_scene: Node = get_current_scene()	
	current_scene.hide()

	scene_loader.show()
	
	scene_loader.load_scene(
		new_scene_path, 
		func(new_scene: Node):
					
			new_scene.reparent(game.multiplayer_spawn_scene)
			game.multiplayer_spawn_scene.show()
			game.local_spawn_scene.hide()
			
			scene_loader.hide()
			
			callback.call(new_scene)
			
			current_scene.queue_free()
	)	
		
@rpc("call_remote", "any_peer")
func remove_player(peer_id: int):
	print("Remove from:", multiplayer.get_unique_id(), ": peer: ", peer_id)
	var existing_player_info: PlayerInfo = get_player_info(peer_id)
	
	if existing_player_info:
		remove_player_info(peer_id)
		OnPlayerRemoved.emit(existing_player_info)

@rpc("call_local","any_peer")
func add_or_update_player_info(player_info_str: String):
	var player_info: PlayerInfo = str_to_var(player_info_str)
	
	if player_info:
		_add_or_update_player_info(player_info)	

func _add_or_update_player_info(player_info: PlayerInfo):
	var found_existing_player_info: PlayerInfo = get_player_info(player_info.peer_id)

	if found_existing_player_info:
		found_existing_player_info.character_stats = player_info.character_stats
		found_existing_player_info.character_scene_file_path = player_info.character_scene_file_path
		
		OnPlayerUpdated.emit(player_info)
	else:
		all_players_info.push_back(player_info)
		
		OnPlayerAdded.emit(player_info)
		
	if multiplayer.is_server():
		var connected_peers = multiplayer.get_peers()
		for connected_peer_id in connected_peers:
			if connected_peer_id != player_info.peer_id:
				# Add new peer to existing peers
				add_or_update_player_info.rpc_id(connected_peer_id, var_to_str(player_info))


func remove_player_info(peer_id: int):
	var player_info_index: int = get_player_info_index(peer_id)	
	all_players_info.remove_at(player_info_index)
	
func get_my_player_info() -> PlayerInfo:
	var player_info: PlayerInfo = GameState.get_player_info(multiplayer.get_unique_id())	
	
	if not player_info and all_players_info.size() == 1:
		return all_players_info[0]
	
	return player_info

func get_player_in_container(peer_id: int, container: Node) -> Character:
	var player_info: PlayerInfo = get_player_info(peer_id)
	for child in container.get_children():
		if child.name == str(player_info.peer_id):
			return child
			
	return null

func get_my_player_in_container(container: Node) -> Character:
	var my_player_info: PlayerInfo = get_my_player_info()
	var my_player: Character = get_player_in_container(my_player_info.peer_id, container)
			
	return my_player
	

func get_player_info(peer_id: int) -> PlayerInfo:
	for index in range(all_players_info.size()):
		var existing_player_info: PlayerInfo = all_players_info[index]
		if existing_player_info.peer_id == peer_id:
			return existing_player_info
			
	return null
			
func get_player_info_index(peer_id: int) -> int:
	for index in range(all_players_info.size()):
		var existing_player_info: PlayerInfo = all_players_info[index]
		if existing_player_info.peer_id == peer_id:
			return index
			
	return -1

func remove_player_from_container(peer_id: int, players_container: Node3D):	
	if players_container.has_node(str(peer_id)):
		var found_player: Character = players_container.get_node(str(peer_id)) as Character
		if found_player:
			players_container.remove_child(found_player)

func log(message: String):
	var function_chain: String
	
	for item in get_stack():
		function_chain += item.function + " -> "
	
	print("On: ", multiplayer.get_unique_id(), " Remote: ", multiplayer.get_remote_sender_id(), " Stack: ", function_chain, "\nMessage: "+ message +"\n\n")
			
func add_or_update_player_in_container(player_info: PlayerInfo, players_container: Node3D) -> Character:	
	var str_peer_id: String = str(player_info.peer_id)
	var player: Character
	
	if(not players_container.has_node(str_peer_id)):
		player = GameState.player_scene.instantiate()
		player.name = str(player_info.peer_id)
		player.set_multiplayer_authority(player_info.peer_id)
		players_container.add_child(player)		
	else:
		player = players_container.get_node(str_peer_id)	
	
	player.character_stats = player_info.character_stats
			
	return player
				
@rpc("call_local","any_peer")
func add_chat_message(sender_name: String, message: String):
	var chat_message: ChatMessage = ChatMessage.new()
	chat_message.peer_id = str(multiplayer.get_remote_sender_id())
	chat_message.sender_name = sender_name
	chat_message.message = message
	
	chat_messages.push_back(chat_message)
		
	OnChatMessageAdded.emit(chat_message)
				
func _process(delta):
	pass
	
func get_current_scene() -> MultiplayerScene:
	if not game:
		return null
		
	if (game.local_spawn_scene and 
		game.local_spawn_scene.visible and 
		game.local_spawn_scene.get_child_count() > 0):
			var local_current_scene: Node3D = game.local_spawn_scene.get_child(0)
			
			if local_current_scene is MultiplayerScene and game.local_spawn_scene.get_child_count() > 0:
				return local_current_scene

	if (game.multiplayer_spawn_scene and 
		game.multiplayer_spawn_scene.visible and 
		game.multiplayer_spawn_scene.get_child_count() > 0):
			
			var multiplayer_current_scene: MultiplayerScene = game.multiplayer_spawn_scene.get_child(0)
			if multiplayer_current_scene:
				return multiplayer_current_scene	
		
	return null
	
func remove_all_players_from_current_scene():
	var current_scene: MultiplayerScene = get_current_scene()
	if current_scene:
		for node in current_scene.players_container.get_children():
			current_scene.players_container.remove_child(node)
		
func switch_to_character_selecter():
	GameState.remove_player.rpc(multiplayer.get_unique_id())
	GameState.remove_all_players_from_current_scene()
	GameState.all_players_info.clear()
	
	GameState.game.load_character_selector()	
	
func capture_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
			
func release_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	
func is_headless_server():
	return DisplayServer.get_name() == "headless"
