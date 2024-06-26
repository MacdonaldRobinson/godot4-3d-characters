extends Sprite3D
class_name HealthBar3D

@onready var health_bar: HealthBar = $SubViewport/HealthBar

@export var character: Character:
	set(value):
		character = value
		health_bar.progress_bar.value = character.character_stats.current_health
		health_bar.progress_bar.max_value = character.character_stats.max_health
		
		var fill = health_bar.progress_bar.get_theme_stylebox("fill")
		var new_fill = fill.duplicate()
		
		health_bar.progress_bar.add_theme_stylebox_override("fill", new_fill)
				

# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	pass # Replace with function body.

func decrease_health_by(damage: int):
	character.character_stats.current_health = character.character_stats.current_health - damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if character.character_stats.max_health == 0:
		return
	
	
	var percentage = float(character.character_stats.current_health) / float(character.character_stats.max_health) * 100
	
	health_bar.progress_bar.value = lerp(health_bar.progress_bar.value, float(character.character_stats.current_health), 0.1) 
	
	var fill = health_bar.progress_bar.get_theme_stylebox("fill")

	if health_bar.progress_bar.value <= 100:		
		fill.bg_color = fill.bg_color.lerp(Color.DARK_GREEN, 1)		 
	
	if health_bar.progress_bar.value <= 70:		
		fill.bg_color = fill.bg_color.lerp(Color.ORANGE, 1)
	
	if health_bar.progress_bar.value <= 30:
		fill.bg_color = fill.bg_color.lerp(Color.RED, 1)
