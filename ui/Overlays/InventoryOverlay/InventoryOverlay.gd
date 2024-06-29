extends Control
class_name InventoryOverlay

@onready var grid_container: GridContainer = $PanelContainer/MarginContainer/ScrollContainer/GridContainer
var slot_scene: PackedScene = preload("res://ui/Overlays/InventoryOverlay/Slot/Slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for item in grid_container.get_children():
		grid_container.remove_child(item)
		
	if GameState.inventory:
		for inventory_item in GameState.inventory.inventory_items:
			var slot: InventorySlot = slot_scene.instantiate()
			grid_container.add_child(slot)
			
			slot.set_inventory_item(GameState.inventory.inventory_items[inventory_item])
		
		
