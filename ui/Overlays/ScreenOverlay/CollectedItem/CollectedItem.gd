extends PanelContainer
class_name CollectedItem

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var item_texture: TextureRect = %ItemTexture
@onready var item_name: Label = %ItemName
@onready var item_quantity: Label = %ItemQuantity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_item(item: Collectable, quantity_collected: int):	
	item_texture.texture = item.item_texture
	item_name.text = item.item_name
	item_quantity.text = str(quantity_collected)

func _on_timer_timeout():
	anim_player.play("FadeOut")
