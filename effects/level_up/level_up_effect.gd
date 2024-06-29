extends Node3D
class_name LevelUpEffect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelUpEffectParticles.one_shot = true
	$LevelUpEffectParticles2.one_shot = true
	$LevelUpText.one_shot = true
	
	$LevelUpEffectParticles.emitting = false
	$LevelUpEffectParticles2.emitting = false	
	$LevelUpText.emitting = false
	
	animation_player.stop()
	pass # Replace with function body.

func play_levelup_effect():
	print("called play_levelup_effect")
	animation_player.play("LevelUp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
