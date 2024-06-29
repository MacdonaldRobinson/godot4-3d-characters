extends Interactable
class_name Collectable

@export var max_collectable_amount: int
@export var quantity_on_collect: int = 1

func interact(interacting_body):
	print("Collected")
