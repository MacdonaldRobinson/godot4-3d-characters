extends Control
class_name InventorySlot

var inventory_item: InventoryItem

@onready var item_texture: TextureRect = %ItemTexture
@onready var item_quantity: Label = %ItemQuantity
@onready var item_name: Label = %ItemName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_inventory_item(inventory_item: InventoryItem):
	self.inventory_item = inventory_item
	
	if inventory_item and item_name:
		#item_name.text = inventory_item.item.item_name
		item_texture.texture = inventory_item.item.item_texture
		item_quantity.text = str(inventory_item.item_quantity)	
