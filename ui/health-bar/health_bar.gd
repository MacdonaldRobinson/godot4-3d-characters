extends Control
class_name HealthBar

@onready var progress_bar: ProgressBar = $ProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func decrease_health_by(damage: int):
	progress_bar.value -= damage
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
