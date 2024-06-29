extends Resource
class_name Inventory

var inventory_items: Dictionary

func get_item(item: Collectable) -> InventoryItem:
	if inventory_items.has(item.item_name):
		var found_inventory_item: InventoryItem = inventory_items[item.item_name]
		return found_inventory_item
	return null
	
func add_or_update_item(item: Collectable):
	if inventory_items.has(item.item_name):
		var found_inventory_item: InventoryItem = inventory_items[item.item_name]
		
		if found_inventory_item.item_quantity < found_inventory_item.item.max_collectable_amount:
			found_inventory_item.item_quantity += item.quantity_on_collect
			
		if found_inventory_item.item_quantity > found_inventory_item.item.max_collectable_amount:
			found_inventory_item.item_quantity = found_inventory_item.item.max_collectable_amount		
		
	else:
		var inventory_item: InventoryItem = InventoryItem.new()
		inventory_item.item = item.duplicate()
		inventory_item.item_quantity += item.quantity_on_collect
		
		inventory_items[item.item_name] = inventory_item
	
