extends Node3D
class_name House

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var is_main_door_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	pass # Replace with function body.

func open_door():
	animation_player.play("DoorOpen")
	is_main_door_open = true

func close_door():
	animation_player.play_backwards("DoorOpen")
	is_main_door_open = false


func _on_area_3d_area_entered(area: Area3D) -> void:
	if !is_main_door_open:
		open_door()


func _on_area_3d_area_exited(area: Area3D) -> void:
	if is_main_door_open:
		close_door()
