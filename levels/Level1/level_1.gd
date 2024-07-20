extends Level
class_name Level1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_players.call_deferred()
	
	if multiplayer.is_server():
		spawn_npc.call_deferred()

func spawn_npc():
	var warrok: Character = preload("res://enemy/Warrok.tscn").instantiate()	
	warrok.character_stats.is_auto_play = true
	npcs_container.add_child(warrok, true)	
	
