extends Control
class_name HudOverlay

@export var character: Character:
	set(value):
		character = value		
		character.camera_controller.camera.current = true
		

@onready var character_name: Label = %NameValue
@onready var character_level: Label = %LevelValue
@onready var character_health: Label = %HealthValue
@onready var character_level_progress: ProgressBar = %LevelProgress
@onready var character_photo: TextureRect = %Photo
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not character:
		return
		
	character_name.text = character.character_stats.name
	character_level.text = str(character.character_stats.current_level)
	character_health.text = str(character.character_stats.current_health) + " / " + str(character.character_stats.max_health)
	
	character_level_progress.max_value = character.character_stats.get_next_level_experiance_points()
	character_level_progress.value = character.character_stats.experiance_points
	character_photo.texture = character.character_stats.photo