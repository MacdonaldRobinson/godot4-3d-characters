extends Weapon
class_name Pistol

@onready var spark: GPUParticles3D = $BarrelLock/Flash/Spark as GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(interacting_body):
	print("Pistol")

func fire():
	var inventory_item: InventoryItem = GameState.inventory.get_item(self)
	
	if inventory_item and inventory_item.item is Pistol:
		var weapon: Pistol = inventory_item.item		
		
		if weapon.ammo_current_amount > 0:
			weapon.ammo_current_amount -= 1
			_fire.rpc()
		else:
			_empty.rpc()

@rpc("call_local","any_peer")
func _fire():
	spark.restart()
	super.fire()	

@rpc("call_local","any_peer")
func _empty():
	empty_sound.play()	
