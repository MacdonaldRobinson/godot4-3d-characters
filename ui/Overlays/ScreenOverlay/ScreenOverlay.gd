extends Control
class_name ScreenOverlay

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var collected_items: VBoxContainer = $CollectedItems
@onready var collected_item_scene: PackedScene = preload("res://ui/Overlays/ScreenOverlay/CollectedItem/CollectedItem.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	for node in collected_items.get_children():
		collected_items.remove_child(node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func taking_damage():
	anim_player.play("TakingDamage")

func collected_item(item: Collectable, quantity_collected: int):	
	var instance: CollectedItem = collected_item_scene.instantiate()
	collected_items.add_child(instance)
	
	instance.set_item(item, quantity_collected)
	
	
	
