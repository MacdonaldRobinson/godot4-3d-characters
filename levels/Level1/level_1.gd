extends Level
class_name Level1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for player in GameState.all_players_info:
		add_or_update_player(player)

	var my_player_character:Character = GameState.get_my_player_in_container(players_container)
	my_player_character.level = self
	screen_ui.character = my_player_character
		
	GameState.OnPlayerAdded.connect(add_or_update_player)
	GameState.OnPlayerUpdated.connect(add_or_update_player)

func add_or_update_player(player_info: PlayerInfo):
	GameState.add_or_update_player_in_container(player_info, players_container)
	
