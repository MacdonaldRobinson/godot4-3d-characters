extends Interactable

signal OnInteracting(interact, interacting_body)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(interacting_body):
	emit_signal("OnInteracting", self, interacting_body)
