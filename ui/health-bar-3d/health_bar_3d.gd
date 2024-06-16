extends Sprite3D
class_name HealthBar3D

@onready var health_bar: HealthBar = $SubViewport/HealthBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func decrease_health_by(damage: int):
	health_bar.progress_bar.value -= damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
