extends Collectable
class_name Weapon

@export var has_ammo: bool
@export var ammo_max_capacity: int
@export var ammo_current_amount: int
@export var ammo_reload_amount: int
@export var ammo_scene: PackedScene
@export var hit_point_effect: PackedScene

@onready var fire_sound: AudioStreamPlayer3D = %FireSound
@onready var reload_sound: AudioStreamPlayer3D = %ReloadSound
@onready var empty_sound: AudioStreamPlayer3D = %EmptySound


signal OnWeaponFired(weapon: Weapon)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact(interacting_body):
	print("Weapon")
	
func fire():		
	fire_sound.play()
	OnWeaponFired.emit(self)
	
func play_hitpoint_effect(ray_cast: RayCast3D):
	var effect: HitPointEffect = hit_point_effect.instantiate() as HitPointEffect
	var collider = ray_cast.get_collider()
	var collision_point = ray_cast.get_collision_point()
	var collision_normal = ray_cast.get_collision_normal()	
	
	if not collider:
		return
		
	if collider is RigidBody3D:
		var body: RigidBody3D = collider as RigidBody3D
		body.apply_central_impulse(collision_normal * -10)
	
	collider.add_child(effect)
	effect.global_position = collision_point	
	
	if effect.process_material is ParticleProcessMaterial:
		var partical_process_material: ParticleProcessMaterial = effect.process_material as ParticleProcessMaterial
		partical_process_material.direction = collision_normal
	
	effect.restart()
	
func reload():	
	var weapon_in_inventory: InventoryItem = GameState.inventory.get_item(self)
	var ammo_in_inventory:InventoryItem = GameState.inventory.get_item(ammo_scene.instantiate())
	var weapon: Weapon = weapon_in_inventory.item as Weapon

	if ammo_in_inventory and ammo_in_inventory.item_quantity > 0 and weapon.ammo_current_amount < weapon.ammo_max_capacity:
		reload_sound.finished.disconnect(_finished_reloading)
		reload_sound.finished.connect(_finished_reloading)
		reload_sound.play()
	
func _finished_reloading():
	var weapon_in_inventory: InventoryItem = GameState.inventory.get_item(self)
	var ammo_in_inventory:InventoryItem = GameState.inventory.get_item(ammo_scene.instantiate())

	if ammo_in_inventory and ammo_in_inventory.item_quantity > 0:
		var ammo: Ammo = ammo_in_inventory.item as Ammo
		
		var ammo_reload_amount = weapon_in_inventory.item.ammo_reload_amount
		
		if ammo_reload_amount > ammo_in_inventory.item_quantity:
			ammo_reload_amount = ammo_in_inventory.item_quantity
		
		if (weapon_in_inventory.item.ammo_current_amount + ammo_reload_amount) > weapon_in_inventory.item.ammo_max_capacity:
			ammo_reload_amount = weapon_in_inventory.item.ammo_max_capacity - weapon_in_inventory.item.ammo_current_amount

		weapon_in_inventory.item.ammo_current_amount += ammo_reload_amount
		ammo_in_inventory.item_quantity -= ammo_reload_amount
				
		
