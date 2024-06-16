extends Sprite3D
class_name HealthBar3D

@onready var health_bar: HealthBar = $SubViewport/HealthBar

@export var max_health: int
@export var current_health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.progress_bar.max_value = max_health
	health_bar.progress_bar.value = current_health
	
	pass # Replace with function body.

func decrease_health_by(damage: int):
	health_bar.progress_bar.value -= damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
