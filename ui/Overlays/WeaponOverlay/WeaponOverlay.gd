extends Control
class_name WeaponOverlay

@onready var weapon_name: Label = %WeaponName as Label
@onready var weapon_texture: TextureRect = %WeaponTexture as TextureRect
@onready var current_ammo_amount: Label = %AmmoCurrentAmount
@onready var max_ammo_capacity: Label = %AmmoMaxCapacity

var inventory_item: InventoryItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_inventory_item(inventory_item: InventoryItem):
	self.inventory_item = inventory_item
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if inventory_item:
		weapon_name.text = inventory_item.item.item_name
		weapon_texture.texture = inventory_item.item.item_texture
		
		if inventory_item.item is Weapon:
			var weapon: Weapon = inventory_item.item
			
			if weapon.has_ammo:
				current_ammo_amount.text = str(weapon.ammo_current_amount)
				max_ammo_capacity.text = str(weapon.ammo_max_capacity)
