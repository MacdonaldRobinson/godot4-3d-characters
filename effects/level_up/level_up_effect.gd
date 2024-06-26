extends Node3D
class_name LevelUpEffect

@onready var levelup_effect_1: GPUParticles3D = $LevelUpEffect1
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.stop()
	pass # Replace with function body.

func play_levelup_effect():
	print("called play_levelup_effect")
	animation_player.play("LevelUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
