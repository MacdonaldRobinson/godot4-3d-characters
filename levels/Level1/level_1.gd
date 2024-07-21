extends Level
class_name Level1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_players.call_deferred()
	
	if multiplayer.is_server():
		spawn_npc.call_deferred()
	
func _process(delta: float) -> void:
	var my_player: Character = GameState.get_my_player_in_container(players_container)
	
	if my_player:
		GameState.game.overlays.hud_overlay.character = my_player
		GameState.game.overlays.hud_overlay.show()
		

func spawn_npc():
	var warrok: Character = preload("res://enemy/Warrok.tscn").instantiate()	
	warrok.character_stats.is_auto_play = true
	npcs_container.add_child(warrok, true)	
	
