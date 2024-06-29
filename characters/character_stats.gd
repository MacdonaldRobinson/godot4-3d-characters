extends Resource
class_name CharacterStats

@export var name: String
@export var current_level: int
@export var current_health: int
@export var max_health: int
@export var number_of_killes: int
@export var experiance_points: int
@export var photo: Texture2D
@export var is_auto_play: bool = false

signal LeveledUp

func get_next_level_experiance_points():
	var multiplier = 100
	var next_level_points = current_level * multiplier
	
	if experiance_points >= next_level_points:
		current_level += 1
		experiance_points = 0
		
		if current_level > 1:
			LeveledUp.emit()
	
	return next_level_points
