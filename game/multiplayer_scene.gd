extends Node3D
class_name MultiplayerScene

@export var players_container:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.game.overlays.chat_overlay.chat_messages.clear()	
	GameState.game.overlays.chat_overlay.sync_with_game_state()
	
	GameState.game.overlays.joystick_overlay.show()
	
	if not GameState.OnPlayerAdded.is_connected(_on_player_added):
		GameState.OnPlayerAdded.connect(_on_player_added)	
		
	if not GameState.OnPlayerUpdated.is_connected(_on_player_updated):
		GameState.OnPlayerUpdated.connect(_on_player_updated)	
	
	if not GameState.OnPlayerRemoved.is_connected(_on_player_removed):
		GameState.OnPlayerRemoved.connect(_on_player_removed)	
		
	pass # Replace with function body.

func _on_player_added(player_info: PlayerInfo):
	GameState.log(var_to_str(player_info))
	GameState.game.overlays.chat_overlay.sync_with_game_state()
	GameState.add_or_update_player_in_container(player_info, players_container)
	
func _on_player_updated(player_info: PlayerInfo):	
	GameState.log(var_to_str(player_info))
	GameState.game.overlays.chat_overlay.sync_with_game_state()
	GameState.add_or_update_player_in_container(player_info, players_container)

func _on_player_removed(player_info: PlayerInfo):
	GameState.game.overlays.chat_overlay.sync_with_game_state()
	GameState.remove_player_from_container(player_info.peer_id, players_container)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
