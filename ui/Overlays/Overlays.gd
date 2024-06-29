extends Control
class_name Overlays

@onready var dead_overlay: DeadOverlay = $DeadOverlay
@onready var minmap_overlay: MiniMapOverlay = $MiniMapOverlay
@onready var interact_overlay: InteractOverly = $InteractOverly
@onready var message_overlay: MessageOverlay = $MessageOverlay
@onready var joystick_overlay: JoystickOverlay = $JoystickOverlay
@onready var chat_overlay: ChatOverlay = $ChatOverlay
@onready var main_menu_overlay: MainMenu = $MainMenu
@onready var inventory_overlay: InventoryOverlay = $InventoryOverlay
@onready var weapon_overlay: WeaponOverlay = $WeaponOverlay
@onready var player_overlay: PlayerOverlay = $PlayerOverlay
@onready var screen_overlay: ScreenOverlay = $ScreenOverlay

@export var camera_controller: CameraController
# Called when the node enters the scene tree for the first time.
func _ready():
	dead_overlay.hide()	
	minmap_overlay.hide()
	interact_overlay.hide()
	message_overlay.hide()
	chat_overlay.hide()
	main_menu_overlay.hide()
	inventory_overlay.hide()
	weapon_overlay.hide()
	player_overlay.hide()


func _input(event):
	if Input.is_action_just_pressed("inventory"):
		if inventory_overlay:
			if inventory_overlay.visible:
				inventory_overlay.hide()
			else:
				inventory_overlay.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
