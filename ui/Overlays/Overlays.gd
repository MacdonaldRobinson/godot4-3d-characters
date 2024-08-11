extends CanvasLayer
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
@onready var settings_overlay: SettingsOverlay = $SettingsOverlay
@onready var hud_overlay: HudOverlay = $HudOverlay

@export var camera_controller: CameraController
# Called when the node enters the scene tree for the first time.
func _ready():
	hide_all_overlays()

func hide_all_overlays():
	dead_overlay.hide()	
	minmap_overlay.hide()
	interact_overlay.hide()
	message_overlay.hide()
	chat_overlay.hide()
	main_menu_overlay.hide()
	inventory_overlay.hide()
	weapon_overlay.hide()
	player_overlay.hide()
	hud_overlay.hide()
	settings_overlay.hide()
	screen_overlay.hide()	
	joystick_overlay.hide()


func _input(event):
	if Input.is_action_just_pressed("inventory"):
		if inventory_overlay:
			if inventory_overlay.visible:
				inventory_overlay.hide()
			else:
				inventory_overlay.show()
				
	if Input.is_action_just_pressed("main_menu_toggle"):
		if main_menu_overlay:
			if main_menu_overlay.visible:
				main_menu_overlay.hide()
			else:
				main_menu_overlay.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
