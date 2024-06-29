extends Control
class_name MessageOverlay

@onready var label: Label = $Label as Label
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	label.text = ""
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_message(message: String):
	label.text = message
